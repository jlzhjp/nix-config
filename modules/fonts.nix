{
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
  ];
}
