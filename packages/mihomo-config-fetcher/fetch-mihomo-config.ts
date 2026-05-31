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
  user_agent?: string;
  output: string;
  basic_auth?: BasicAuth;
};

const defaultConfigPath = "/etc/mihomo/config-fetcher.toml";
const defaultOutputPath = "/etc/mihomo/config.yaml";
const configSchema = z.object({
  url: z.url(),
  user_agent: z.string().min(1).optional(),
  output: z.string().min(1).default(defaultOutputPath),
  basic_auth: z.object({
    username: z.string().min(1),
    password: z.string().min(1),
  }).optional(),
});

export function parseConfig(toml: string): Config {
  return configSchema.parse(parse(toml));
}

export function basicAuthHeader(username: string, password: string): string {
  return `Basic ${encodeBase64(`${username}:${password}`)}`;
}

function sourceForLog(url: string): string {
  const parsed = new URL(url);
  return `${parsed.origin}${parsed.pathname}`;
}

export async function fetchMihomoConfig(
  configPath = defaultConfigPath,
  fetcher: typeof fetch = fetch,
) {
  const config = parseConfig(await Deno.readTextFile(configPath));
  const outputPath = config.output;
  const temporaryPath = `${outputPath}.tmp-${Deno.pid}`;
  const source = sourceForLog(config.url);

  console.info(
    `Fetching Mihomo configuration from ${source} using ${configPath}`,
  );

  const headers = new Headers();

  if (config.user_agent) {
    headers.set("User-Agent", config.user_agent);
  }

  if (config.basic_auth) {
    headers.set(
      "Authorization",
      basicAuthHeader(
        config.basic_auth.username,
        config.basic_auth.password,
      ),
    );
  }

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
    console.info(
      `Fetched Mihomo configuration to ${outputPath} (${body.length} bytes)`,
    );
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
  const configPath = Deno.args[0] ?? defaultConfigPath;

  try {
    await fetchMihomoConfig(configPath);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(
      `Failed to fetch Mihomo configuration using ${configPath}: ${message}`,
    );
    Deno.exit(1);
  }
}
