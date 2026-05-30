{
  config,
  lib,
  pkgs,
  ...
}:

{
  xdg.configFile."doom" = {
    source = ../config/doom;
    force = true;
  };

  home.activation.doomSync = lib.hm.dag.entryAfter [ "installPackages" ] ''
    doom="${config.home.homeDirectory}/.config/emacs/bin/doom"
    if [ -x "$doom" ]; then
      run env EMACS="${lib.getExe pkgs.emacs-pgtk}" "$doom" sync
    fi
  '';
}
