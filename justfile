default: switch

verify: format lint

switch:
    @echo "Rebuilding home manager"
    home-manager switch --flake .#akari
    @echo "Rebuilding system components"
    sudo fedora-nix-rebuild .#atri

update-packages:
    nix flake update

update: update-packages
    just switch

format:
    nixfmt flake.nix home.nix modules/*.nix
    fnlfmt --fix config/nvim/*.fnl

lint:
    statix check .
    deadnix .
    fennel --add-fennel-path config/nvim/?.fnl --add-fennel-path config/nvim/?/init.fnl --compile config/nvim/init.fnl > /tmp/home-manager-nvim-init.lua
