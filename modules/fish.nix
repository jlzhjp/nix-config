{
  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
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
      nf = "nix flake update";
    };
  };

  xdg.configFile."fish/config.fish".force = true;
}
