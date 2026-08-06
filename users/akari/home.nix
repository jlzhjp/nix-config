{
  config,
  lib,
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
        moon
        pkg-config
        playwright-mcp
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

    sessionPath = [
      "${config.home.homeDirectory}/.local/share/racket/${pkgs.racket.version}/bin"
      # fix glycin bug in flatpak
      "/bin"
      "/usr/bin"
    ];

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
        vi = "nvim --clean";
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
    dataFile =
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair "fcitx5/rime/${name}" {
          # Rime uses source mtimes to decide whether compiled schemas are stale.
          # Nix store files have epoch mtimes, so link to the live checkout here.
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/akari/config/rime/${name}";
          force = true;
        }
      ) (lib.filterAttrs (_: type: type == "regular") (builtins.readDir ./config/rime))
      // {
        "fcitx5/rime/essay-zh-hans.txt" = {
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/rime/rime-essay-simp/dc06d4c96ae72ad46b29e3aa824a5d1e8f721fd0/essay-zh-hans.txt";
            hash = "sha256-k/wZF0P8K5tFSlzuDd4QKv7xpWb057MiifglgOTY86w=";
          };
          force = true;
        };
        "fcitx5/rime/zh-hans-t-essay-bgc.gram" = {
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/f8ce3b534733e489a8470a7c2adf5a154e8ea069/zh-hans-t-essay-bgc.gram";
            hash = "sha256-xS3rVrFkLk9WoYkm//y0twOFgo+SG/rJLF/0BVzOU3c=";
          };
          force = true;
        };
        "fcitx5/rime/zh-hans-t-essay-bgw.gram" = {
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/f8ce3b534733e489a8470a7c2adf5a154e8ea069/zh-hans-t-essay-bgw.gram";
            hash = "sha256-08skOMH9zWqFXdbKj1wQYKKSc8a2TCwsaa9nzXG2qn4=";
          };
          force = true;
        };
        "fcitx5/rime/zh-hant-t-essay-bgc.gram" = {
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/97bf55046aad163c3d1881abae5312040b1bbed9/zh-hant-t-essay-bgc.gram";
            hash = "sha256-fPZNUjepLcz5010Ex27zyRlFBgOmB6OI0VbucGPwRHA=";
          };
          force = true;
        };
        "fcitx5/rime/zh-hant-t-essay-bgw.gram" = {
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/97bf55046aad163c3d1881abae5312040b1bbed9/zh-hant-t-essay-bgw.gram";
            hash = "sha256-BIjr1miPkAo5IA8reU8vmby/Ho/CcoCuSiMksIsVWcE=";
          };
          force = true;
        };
      };
  };
}
