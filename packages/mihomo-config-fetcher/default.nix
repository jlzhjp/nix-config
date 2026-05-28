{
  deno,
  writeShellApplication,
}:

writeShellApplication {
  name = "mihomo-config-fetcher";
  runtimeInputs = [ deno ];

  text = ''
    exec deno run --quiet --allow-net --allow-read=/etc/mihomo --allow-write=/etc/mihomo ${./fetch-mihomo-config.ts} "$@"
  '';
}
