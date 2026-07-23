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
        packageOf = input: name: input.packages.${pkgs.stdenv.hostPlatform.system}.${name};
        codex = packageOf inputs.codex-cli-nix "default";
        anki-tts = packageOf inputs.anki-tts "default";
      in
      with pkgs;
      [
        # AI assistants
        codex
        opencode
        pi-coding-agent

        # System
        bind
        tcpdump
        ffmpeg-full

        # CLI tools
        anki-tts
        aria2
        bat
        btop
        delta
        distrobox
        fastfetch
        fd
        jq
        lsof
        mosh
        openssl
        psmisc
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

        # Database
        sqlite

        # Editors
        emacs-pgtk
        vscode
        zed-editor

        # Language toolchains
        fish-lsp

        bun
        deno
        nodejs_latest
        pnpm
        oxlint
        oxfmt

        clang
        clang-tools
        cmake

        clojure
        clojure-lsp
        neil

        go
        gopls
        harper

        typst
        tinymist

        micromamba
        racket
        rustup

        # Password Manager
        bitwarden-cli
        bitwarden-desktop
      ];

    sessionPath = [ "${config.home.homeDirectory}/.local/share/racket/${pkgs.racket.version}/bin" ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
      CC = "clang";
      CXX = "clang++";
      MAMBA_ROOT_PREFIX = "${config.home.homeDirectory}/.local/share/mamba";
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
      interactiveShellInit = ''
        set -gx MAMBA_NO_PROMPT 1
        ${pkgs.micromamba}/bin/micromamba shell hook --shell fish | source
      '';
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
        mamba = "micromamba";
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
