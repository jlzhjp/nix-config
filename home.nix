{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./modules/atuin.nix
    ./modules/direnv.nix
    ./modules/eza.nix
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/nh.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/zoxide.nix
  ];

  home = {
    username = "akari";
    homeDirectory = "/var/home/akari";
    stateVersion = "25.11";

    packages = [
      pkgs.actionlint
      pkgs.bat
      pkgs.bun
      pkgs.clang
      pkgs.clang-tools
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.deadnix
      pkgs.delta
      pkgs.fastfetch
      pkgs.fennel-ls
      pkgs.fd
      pkgs.fish-lsp
      pkgs.fnlfmt
      pkgs.go
      pkgs.gopls
      pkgs.gh
      pkgs.git-filter-repo
      pkgs.gnumake
      pkgs.harper
      pkgs.just
      pkgs.luaPackages.fennel
      pkgs.nixd
      pkgs.nixfmt
      pkgs.nix-output-monitor
      pkgs.nodejs
      pkgs.pnpm
      pkgs.pkg-config
      pkgs.rclone
      pkgs.ripgrep
      pkgs.rustup
      pkgs.statix
      pkgs.tree-sitter
      pkgs.ty
      pkgs.uv
      pkgs.yaml-language-server
      pkgs.yq
    ];

    sessionPath = [
      "${config.home.profileDirectory}/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };

  programs.home-manager.enable = true;
}
