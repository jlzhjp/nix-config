{
  lib,
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
  ];

  home.activation.flatpakFontAccess = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v flatpak > /dev/null 2>&1; then
      run flatpak override --user \
        --filesystem=/nix/store:ro \
        --filesystem=xdg-config/fontconfig:ro
    else
      echo "Skipping Flatpak font access override because flatpak is not on PATH"
    fi
  '';
}
