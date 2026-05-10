{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/fonts.nix
    ./modules/neovim.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/wallpapers.nix
  ];

  home = {
    username = "akari";
    homeDirectory = "/home/akari";
    stateVersion = "25.11";

    packages = with pkgs; [
      actionlint
      bat
      bun
      clang
      clang-tools
      (coq.withPackages (
        ps: with ps; [
          stdlib
          coq-lsp
        ]
      ))
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      delta
      fastfetch
      fd
      fish-lsp
      go
      gopls
      gh
      git-filter-repo
      gnumake
      harper
      just
      nodejs
      pnpm
      pkg-config
      prettier
      rclone
      racket
      ripgrep
      rustup
      shellcheck
      shfmt
      tree-sitter
      ty
      uv
      yaml-language-server
      yq
      vscode
      zed-editor
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      shellAbbrs = {
        gs = "git status --short";
        nf = "nix flake update";
      };
      shellAliases = {
        cat = "bat";
        df = "df -h";
        diff = "diff --color=auto";
        du = "du -h";
        grep = "grep --color=auto";
        la = "eza --all --group-directories-first --git --long";
        ll = "eza --group-directories-first --git --long";
        ls = "eza --group-directories-first";
        tree = "eza --tree";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    ghostty = {
      enable = true;
      settings = {
        background-blur = true;
        background-opacity = 0.85;
        font-family = "Iosevka Nerd Font";
        font-size = 16;
        theme = "Dark Modern";
      };
    };

    git = {
      enable = true;
      settings = {
        core.pager = "delta";
        delta.navigate = true;
        interactive.diffFilter = "delta --color-only";
        merge.conflictStyle = "zdiff3";
        user = {
          email = "jvjdev@gmail.com";
          name = "akari";
        };
      };
    };

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nix-config";
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg.configFile."fish/config.fish".force = true;
  xdg.enable = true;
}
