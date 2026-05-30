{ config, lib, ... }:

{
  xdg.configFile."doom" = {
    source = ../config/doom;
    force = true;
  };

  home.activation.doomSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    doom="${config.home.homeDirectory}/.config/emacs/bin/doom"
    if [ -x "$doom" ]; then
      run "$doom" sync
    fi
  '';
}
