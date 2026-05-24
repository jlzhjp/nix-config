import { assertEquals, assertRejects, assertThrows } from "jsr:@std/assert@1";
import {
  basicAuthHeader,
  fetchMihomoConfig,
  parseConfig,
} from "./fetch-mihomo-config.ts";

Deno.test("parseConfig applies default output path", () => {
  const config = parseConfig(`
url = "https://example.com/mihomo.yaml"
user_agent = "mihomo-config-fetch-test"

[basic_auth]
username = "akari"
password = "secret"
`);

  assertEquals(config, {
    url: "https://example.com/mihomo.yaml",
    user_agent: "mihomo-config-fetch-test",
    output: "/etc/mihomo/config.yaml",
    basic_auth: {
      username: "akari",
      password: "secret",
    },
  });
});

Deno.test("parseConfig accepts an explicit output path", () => {
  const config = parseConfig(`
url = "https://example.com/mihomo.yaml"
user_agent = "mihomo-config-fetch-test"
output = "/tmp/mihomo.yaml"

[basic_auth]
username = "akari"
password = "secret"
`);

  assertEquals(config.output, "/tmp/mihomo.yaml");
});

Deno.test("parseConfig rejects missing basic auth", () => {
  assertThrows(
    () =>
      parseConfig(`
url = "https://example.com/mihomo.yaml"
user_agent = "mihomo-config-fetch-test"
`),
  );
});

Deno.test("basicAuthHeader encodes username and password", () => {
  assertEquals(basicAuthHeader("akari", "secret"), "Basic YWthcmk6c2VjcmV0");
});

Deno.test("fetchMihomoConfig fetches with configured headers and writes output", async () => {
  const directory = await Deno.makeTempDir();
  const configPath = `${directory}/config-fetcher.toml`;
  const outputPath = `${directory}/config.yaml`;

  await Deno.writeTextFile(
    configPath,
    `
url = "https://example.com/mihomo.yaml"
user_agent = "mihomo-config-fetch-test"
output = "${outputPath}"

[basic_auth]
username = "akari"
password = "secret"
`,
  );

  const requests: Request[] = [];
  await fetchMihomoConfig(configPath, (input, init) => {
    const request = new Request(input, init);
    requests.push(request);

    return Promise.resolve(new Response("mixed-port: 7890\n"));
  });

  assertEquals(await Deno.readTextFile(outputPath), "mixed-port: 7890\n");
  assertEquals(requests.length, 1);
  assertEquals(
    requests[0].headers.get("authorization"),
    "Basic YWthcmk6c2VjcmV0",
  );
  assertEquals(
    requests[0].headers.get("user-agent"),
    "mihomo-config-fetch-test",
  );
});

Deno.test("fetchMihomoConfig rejects empty responses", async () => {
  const directory = await Deno.makeTempDir();
  const configPath = `${directory}/config-fetcher.toml`;
  const outputPath = `${directory}/config.yaml`;

  await Deno.writeTextFile(
    configPath,
    `
url = "https://example.com/mihomo.yaml"
user_agent = "mihomo-config-fetch-test"
output = "${outputPath}"

[basic_auth]
username = "akari"
password = "secret"
`,
  );

  await assertRejects(
    () =>
      fetchMihomoConfig(configPath, () => Promise.resolve(new Response(""))),
    Error,
    "response body is empty",
  );
});
