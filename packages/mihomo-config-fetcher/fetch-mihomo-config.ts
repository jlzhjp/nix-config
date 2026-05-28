import { encodeBase64 } from "jsr:@std/encoding@1/base64";
import { dirname } from "jsr:@std/path@1/dirname";
import { parse } from "jsr:@std/toml@1";
import * as z from "jsr:@zod/zod@4";

type BasicAuth = {
  username: string;
  password: string;
};

type Config = {
  url: string;
  user_agent: string;
  output: string;
  basic_auth: BasicAuth;
};

const defaultConfigPath = "/etc/mihomo/config-fetcher.toml";
const defaultOutputPath = "/etc/mihomo/config.yaml";
const configSchema = z.object({
  url: z.url(),
  user_agent: z.string().min(1),
  output: z.string().min(1).default(defaultOutputPath),
  basic_auth: z.object({
    username: z.string().min(1),
    password: z.string().min(1),
  }),
});

export function parseConfig(toml: string): Config {
  return configSchema.parse(parse(toml));
}

export function basicAuthHeader(username: string, password: string): string {
  return `Basic ${encodeBase64(`${username}:${password}`)}`;
}

export async function fetchMihomoConfig(
  configPath = defaultConfigPath,
  fetcher: typeof fetch = fetch,
) {
  const config = parseConfig(await Deno.readTextFile(configPath));
  const outputPath = config.output;
  const temporaryPath = `${outputPath}.tmp-${Deno.pid}`;

  const headers = new Headers({
    Authorization: basicAuthHeader(
      config.basic_auth.username,
      config.basic_auth.password,
    ),
    "User-Agent": config.user_agent,
  });

  const abortController = new AbortController();
  const timeout = setTimeout(() => abortController.abort(), 60_000);

  try {
    const response = await fetcher(config.url, {
      headers,
      redirect: "follow",
      signal: abortController.signal,
    });

    if (!response.ok) {
      throw new Error(
        `fetch failed: HTTP ${response.status} ${response.statusText}`,
      );
    }

    const body = await response.text();
    if (body.trim() === "") {
      throw new Error("fetch failed: response body is empty");
    }

    await Deno.mkdir(dirname(outputPath), { recursive: true, mode: 0o750 });
    await Deno.writeTextFile(temporaryPath, body, { mode: 0o600 });
    await Deno.rename(temporaryPath, outputPath);
    await Deno.chmod(outputPath, 0o600);
  } finally {
    clearTimeout(timeout);

    try {
      await Deno.remove(temporaryPath);
    } catch (error) {
      if (!(error instanceof Deno.errors.NotFound)) {
        throw error;
      }
    }
  }
}

if (import.meta.main) {
  await fetchMihomoConfig(Deno.args[0] ?? defaultConfigPath);
}
