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
    ./modules/wallpapers.nix
  ];

  home = {
    username = "akari";
    homeDirectory = "/home/akari";
    stateVersion = "25.11";

    packages = with pkgs; [
      # AI assistants
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

      # CLI tools
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

      # Editors
      vscode
      zed-editor

      # Language servers and formatters
      clang-tools
      fish-lsp
      gopls
      harper
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

    ghostty = {
      enable = true;
      settings = {
        background-blur = true;
        background-opacity = 0.85;
        font-family = "Iosevka Nerd Font";
        font-size = 16;
        theme = "Kanagawabones";
      };
    };

    git = {
      enable = true;
      settings = {
        core.pager = "delta";
        delta.navigate = true;
        commit.gpgsign = true;
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
        };
        interactive.diffFilter = "delta --color-only";
        merge.conflictStyle = "zdiff3";
        user = {
          email = "jvjdev@gmail.com";
          name = "akari";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILK9mbY23GXiMBEuoOnRFHOVQbfjbkJDMYKMy+8Jgjc2";
        };
        alias = {
          st = "status -sb";
          co = "checkout";
          sw = "switch";
          br = "branch";
          ci = "commit";
          cm = "commit -m";
          ca = "commit --amend";
          cane = "commit --amend --no-edit";
          aa = "add -A";

          unstage = "restore --staged --";
          last = "log -1 HEAD --stat";

          lg = "log --oneline --graph --decorate --all";
          ll = "log --oneline --decorate -20";
          lga = "log --graph --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(auto)%d%Creset %s %Cgreen(%an)%Creset' --date=short --all";

          df = "diff";
          dfs = "diff --staged";
          dfh = "diff HEAD";
          dft = "difftool";

          rb = "rebase";
          rbi = "rebase -i";
          pick = "cherry-pick";
          mt = "mergetool";

          pl = "pull --ff-only";
          ps = "push";
          pf = "push --force-with-lease";

          save = "stash push -u -m";
          pop = "stash pop";
          sl = "stash list";
          sd = "stash show -p";

          undo = "reset --soft HEAD~1";
          discard = "restore --";
          wipe = "reset --hard HEAD";
          cleanall = "clean -fd";

          who = "shortlog -sn";
          root = "rev-parse --show-toplevel";
          aliases = "config --get-regexp ^alias\\.";
        };
      };
    };

    nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nix-config";
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        theme = "kanagawa";
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "fish/config.fish".force = true;
      "zellij/config.kdl".force = true;
      "git/allowed_signers".text = ''
        jvjdev@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILK9mbY23GXiMBEuoOnRFHOVQbfjbkJDMYKMy+8Jgjc2
      '';
    };
  };
}
