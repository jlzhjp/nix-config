{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/direnv.nix
    ./modules/eza.nix
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/fonts.nix
    ./modules/neovim.nix
    ./modules/nh.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/wallpapers.nix
    ./modules/zoxide.nix
  ];

  home = {
    username = "akari";
    homeDirectory = "/var/home/akari";
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
      zed-editor
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };

  xdg.enable = true;

  targets.genericLinux = {
    enable = true;
    gpu.enable = false;
  };
}
