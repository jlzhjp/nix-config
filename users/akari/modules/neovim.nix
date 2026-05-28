{ pkgs, ... }:

let
  source = ../config/nvim;
  nvimConfig = pkgs.runCommand "nvim-config" { nativeBuildInputs = [ pkgs.luaPackages.fennel ]; } ''
    mkdir -p "$out"

    fennel \
      --add-fennel-path "${source}/?.fnl" \
      --add-fennel-path "${source}/?/init.fnl" \
      --compile "${source}/init.fnl" \
      > "$out/init.lua"
  '';
in
{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
  };

  xdg.configFile = {
    "nvim/init.lua".source = nvimConfig + "/init.lua";
    "nvim/queries".source = source + "/queries";
  };
}
