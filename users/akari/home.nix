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
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/wallpapers.nix
  ];

  fonts.fontconfig.enable = false;

  home = {
    username = "akari";
    homeDirectory = "/home/akari";
    stateVersion = "25.11";

    packages =
      let
        codex = inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system};
        antigravity = inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system};
      in
      with pkgs;
      [
        # AI assistants
        codex.default
        antigravity.default
        antigravity.google-antigravity-cli
        opencode
        pi-coding-agent

        # System
        bind
        tcpdump
        ffmpeg-full

        # CLI tools
        aria2
        bat
        delta
        distrobox
        fastfetch
        fd
        jq
        mosh
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

        # Cloud Native
        kubectl
        kubelogin-oidc
        kubernetes-helm
        fluxcd

        # Editors
        emacs-pgtk
        vscode
        zed-editor

        # Language servers and formatters
        clang-tools
        clojure-lsp
        fish-lsp
        gopls
        harper
        tinymist

        # Language toolchains
        bun
        clang
        clojure
        cmake
        deno
        go
        neil
        nodejs
        pnpm
        racket
        rustup
        typst

        # Password Manager
        bitwarden-cli
        bitwarden-desktop
      ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
      CC = "clang";
      CXX = "clang++";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
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

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nix-config";
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom" = {
        source = ./config/doom;
        force = true;
      };
      "fish/config.fish".force = true;
      "git/allowed_signers".text = ''
        jvjdev@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILK9mbY23GXiMBEuoOnRFHOVQbfjbkJDMYKMy+8Jgjc2
      '';
    };
  };
}
