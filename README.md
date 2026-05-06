# Fedora Nix Configuration

Fedora bootc Nix configuration and Home Manager profile for `akari`.

## Bootstrap

Install Nix first, then place this repository at the documented config path:

```sh
git clone https://github.com/jlzhjp/dotfiles ~/nix-config
cd ~/nix-config
```

Apply the flake once with `nix run`. This works even before the
`home-manager` command has been installed into the user profile:

```sh
nix run github:nix-community/home-manager -- switch --flake .#akari
```

After the first switch, use the installed command:

```sh
home-manager switch --flake ~/nix-config#akari
```

## System Configuration

The flake also exposes Fedora system components under
`fedoraNixConfigurations.${host}`. For example, the current host is available
as `fedoraNixConfigurations.atri`.

- `fedoraNixConfigurations.${host}.prefix` is a Unix-style Nix prefix for
  global packages and system helper tools.
- Add `prefix/bin` to `PATH`.
- Add `prefix/share` to the XDG data directories.
- Link `fedoraNixConfigurations.${host}.graphicsDrivers` to
  `/run/opengl-driver` so Nix GUI applications can find the graphics drivers.

An example rebuild helper is available at
<https://github.com/jlzhjp/silverblue/blob/main/bin/fedora-nix-rebuild>.

## Daily Use

Format, lint, and apply both Home Manager and system components:

```sh
just
```

Run only formatting or checks:

```sh
just format
just lint
```

Update inputs and apply:

```sh
nix flake update
just
```

## Layout

- `flake.nix` exposes Home Manager and Fedora Nix system configurations.
- `akari/home.nix` contains the `akari` Home Manager profile, packages, and
  shared session settings.
- `akari/modules/` contains Home Manager modules for managed programs.
- `akari/config/` contains application source files used by those modules.
- `akari/config/nvim/init.fnl` is compiled by Home Manager into Neovim's
  `init.lua`.
- `atri/system.nix` contains Fedora system components for host `atri`,
  including the system prefix and graphics driver build environments.
