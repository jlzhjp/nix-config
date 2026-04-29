{
  programs.fish = {
    enable = true;
    shellAliases = {
      diff = "diff --color=auto";
      df = "df -h";
      du = "du -h";
      grep = "grep --color=auto";
      la = "eza --all --group-directories-first --git --long";
      ll = "eza --group-directories-first --git --long";
      ls = "eza --group-directories-first";
      tree = "eza --tree";
    };

    shellAbbrs = {
      gs = "git status --short";
      jv = "just verify";
      js = "just switch";
      nf = "nix flake update";
    };
  };

  xdg.configFile."fish/config.fish".force = true;
}
