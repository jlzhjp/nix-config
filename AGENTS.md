# AGENTS.md

## Working Rules

- This repository is a Nix Home Manager configuration for user `akari`.
- Ask for elevated approval before running `nix`, `home-manager`, or other commands that need to escape the sandbox.
- Do not reintroduce Neovim runtime Fennel compilation. Home Manager builds `config/nvim/init.fnl` into the installed Neovim `init.lua`.
- Do not manage `~/.config/nvim` as one immutable directory. Manage `nvim/init.lua` (generated from `config/nvim/init.fnl`) and explicit subpaths like `nvim/queries`, while keeping the `~/.config/nvim` root writable so `vim.pack` can create its untracked lockfile there.
- Keep user-facing Home Manager code in modules under `modules/`; keep application source files under `config/`.
- Add simple CLI tools to `home.packages`; use `programs.*` modules only when configuring the program beyond installation.
- Prefer nixpkgs Zed as `pkgs.zed-editor` in `home.packages` unless the user explicitly asks for the upstream `zed-industries/zed` flake.
- Add Racket from nixpkgs as `pkgs.racket` in `home.packages`.
- Add formatter-only tools such as Prettier directly to `home.packages` unless repository-local formatter configuration is also needed.
- Keep install-only shell tools such as ShellCheck and shfmt in `home.packages`.
- Add install-only font packages such as Nerd Fonts directly to `home.packages`.
- Keep standalone font packages in `modules/fonts.nix` once they are part of the maintained set.
- Use `pkgs.nerd-fonts.fira-code` for Fira Code Nerd Font.
- Enable `fonts.fontconfig` when managing user fonts so fontconfig-based applications can discover Home Manager-installed fonts.
- Keep Flatpak font filesystem access in `modules/fonts.nix` as a user override activation step after `writeBoundary`, so Flatpak apps can read `/nix/store` fonts and user fontconfig. Flatpak itself is not managed by Nix here; call the ambient `flatpak` command instead of `pkgs.flatpak`.
- Keep generated files out of the source tree unless the user explicitly asks otherwise.
- Enable Home Manager's generic Linux target with `targets.genericLinux.enable = true;` for this non-NixOS environment.
- Enable Home Manager's XDG integration with `xdg.enable = true;` at the top level in `home.nix`.
- Prefer `pkgs.stdenv.hostPlatform.system` over `pkgs.system`; `pkgs.system` emits an evaluation warning in current nixpkgs.
- Configure Git identity with `programs.git.settings.user.name` and `programs.git.settings.user.email`; `programs.git.userName` and `programs.git.userEmail` are renamed aliases that emit warnings.
- Atuin is intentionally not managed here; do not re-add `programs.atuin` or import an Atuin module unless the user asks.
- Keep repository automation in `.github`; CI should install Nix with flakes enabled before running `nix flake check`.
- Pin GitHub Actions to commit hashes and keep the source tag in a trailing comment so Renovate can update the pinned SHA.
- Renovate's Nix manager is beta and must be explicitly enabled with `nix.enabled = true`; `enabledManagers = ["nix"]` alone is not enough.
- Renovate uses `Asia/Tokyo` timezone and should run lock file maintenance daily between 02:00 and 04:00.
- Preserve Vim-like tmux pane resize semantics for Prefix + `>`, `<`, `+`, and `-`: change the current pane's absolute width/height. Do not pass raw tmux format expressions directly to `resize-pane -x/-y`; expand computed sizes first so `resize-pane` receives literal numbers.
- Sync the OneDrive Wallpapers rclone remote into `~/Wallpapers`; do not mount it with FUSE. Run the sync once via the user service at login, then use a user timer to repeat it every 30 minutes.
- Do not revert user changes or unrelated work in this repository.
- Every time you make an edit or refactor, update this `AGENTS.md` with any repo-specific lesson learned or rule that would prevent repeating a mistake in future work. Also update persistent memory when the lesson should survive outside this repository.

## Formatting And Checks

After editing, run the full formatter and linter workflow:

```sh
just verify
```

Use `just format` for formatting only and `just lint` for checks only.

Use `just` or `just switch` to apply the Home Manager configuration.

Use elevated approval for Nix/Home Manager commands, including `just`, `just switch`, and `home-manager switch --flake .#akari`. If the `just` package is not installed yet, switch Home Manager first or run the commands from `justfile` directly.
