{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./modules/flatpak.nix
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
      # AI assistants
      gemini-cli
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

      # CLI tools
      bat
      delta
      distrobox
      fastfetch
      fd
      jq
      openssl
      rclone
      ripgrep
      unrar
      wl-clipboard
      yq-go

      # Development tools
      gh
      git-filter-repo
      gnumake
      just
      pkg-config
      tree-sitter

      # Editors
      vscode
      zed-editor

      # Language servers and formatters
      clang-tools
      fish-lsp
      gopls
      harper
      ty
      tinymist

      # Language toolchains
      bun
      clang
      deno
      go
      nodejs
      pnpm
      racket
      rustup
      typst
      uv
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
      CC = "clang";
      CXX = "clang++";
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
        theme = "Modus Vivendi";
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
