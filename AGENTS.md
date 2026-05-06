# AGENTS.md

## Working Rules

- This repository contains a Fedora Nix system configuration and a Home Manager profile for user `akari`.
- Ask for elevated approval before running `nix`, `home-manager`, `just`, or other commands that need to escape the sandbox.
- Keep user-facing Home Manager code in modules under `akari/modules/`; keep application source files under `akari/config/`.
- Add simple CLI tools to `home.packages`; use `programs.*` modules only when configuring the program beyond installation.
- Keep generated files out of the source tree unless the user explicitly asks otherwise.
- Do not revert user changes or unrelated work in this repository.

## Fedora Nix System

- Keep Fedora system components under `fedoraNixConfigurations.${host}`.
- Keep the current host implementation in `atri/system.nix`.
- Put global packages and system helper tools in `fedoraNixConfigurations.${host}.prefix`, which is treated as a Unix-style prefix.
- The rebuild helper is expected to add `prefix/bin` to `PATH` and `prefix/share` to XDG data directories.
- Put graphics driver packages in `fedoraNixConfigurations.${host}.graphicsDrivers`.
- The rebuild helper is expected to link `fedoraNixConfigurations.${host}.graphicsDrivers` to `/run/opengl-driver` so Nix GUI apps can use the graphics stack.
- Document examples using `~/nix-config` as the config path.
- An example helper can be found at <https://github.com/jlzhjp/silverblue/blob/main/bin/fedora-nix-rebuild>.

## Home Manager

- Keep the `akari` profile rooted at `akari/home.nix`.
- Enable the generic Linux target with `targets.genericLinux.enable = true;` for this non-NixOS environment.
- Enable XDG integration with `xdg.enable = true;` at the top level in `akari/home.nix`.
- Prefer `pkgs.stdenv.hostPlatform.system` over `pkgs.system`; `pkgs.system` emits an evaluation warning.
- Configure Git identity with `programs.git.settings.user.name` and `programs.git.settings.user.email`; the older aliases emit warnings.
- Atuin is intentionally not managed here; do not re-add it unless the user asks.

## Applications

- Neovim: Home Manager builds `akari/config/nvim/init.fnl` into the installed `init.lua`; do not reintroduce runtime Fennel compilation.
- Neovim: manage `nvim/init.lua` and explicit subpaths like `nvim/queries`, not the whole `~/.config/nvim` directory, so `vim.pack` can create its untracked lockfile.
- Fonts: keep standalone font packages in `akari/modules/fonts.nix`, use `pkgs.nerd-fonts.fira-code` for Fira Code Nerd Font, and enable `fonts.fontconfig` when managing user fonts.
- Keep Flatpak font filesystem access in `akari/modules/fonts.nix` as a user override activation step after `writeBoundary`, so Flatpak apps can read `/nix/store` fonts and user fontconfig. Flatpak itself is not managed by Nix here; call the ambient `flatpak` command instead of `pkgs.flatpak`.
- Prefer nixpkgs Zed as `pkgs.zed-editor` unless the user explicitly asks for the upstream `zed-industries/zed` flake.
- Sync the OneDrive Wallpapers rclone remote into `~/Wallpapers`; do not mount it with FUSE. Run it once at login and every 30 minutes by timer.
- Preserve Vim-like tmux pane resize semantics for Prefix + `>`, `<`, `+`, and `-`: change the current pane's absolute width/height. Expand computed sizes before passing them to `resize-pane -x/-y`.

## Automation

- Keep repository automation in `.github`; CI should install Nix with flakes enabled before running `nix flake check`.
- Pin GitHub Actions to commit hashes and keep the source tag in a trailing comment so Renovate can update the pinned SHA.
- Renovate's Nix manager must be explicitly enabled with `nix.enabled = true`; `enabledManagers = ["nix"]` alone is not enough.
- Renovate uses the `Asia/Tokyo` timezone and should run lock file maintenance daily between 02:00 and 04:00.
- Record only durable repo-specific lessons in this file; do not log routine edits.

## Formatting And Checks

- After editing, run `just verify`.
- Use `just format` for formatting only and `just lint` for checks only.
- Use `just` or `just switch` to apply the Home Manager configuration and Fedora Nix system components.
- Use `just update-packages` for `nix flake update`, and `just update` to update inputs before switching.
- If `just` is not installed yet, switch Home Manager first or run the commands from `justfile` directly.
