{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    escapeTime = 10;
    focusEvents = true;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      copycat
      open
      prefix-highlight
      resurrect
      continuum
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g set-clipboard on
      set -g @continuum-restore 'on'

      # Enable true color when the outer terminal supports it.
      set -as terminal-features ",xterm-256color:RGB"

      # Vim Ctrl-w style tab shortcuts.
      # In tmux terms, a Vim tabview maps to a tmux window and a Vim window maps to a tmux pane.
      bind T break-pane
      bind o kill-pane -a
      bind n split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Vim Ctrl-w style window management.
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind q kill-pane
      bind x swap-pane -D
      bind m select-pane -m

      # Vim Ctrl-w style moving windows.
      bind r rotate-window -D
      bind R rotate-window -U

      # Vim Ctrl-w style navigation between windows.
      bind C-a select-pane -t "{next}"
      bind C-w select-pane -t "{next}"
      bind w select-pane -t "{next}"
      bind Up select-pane -U
      bind Down select-pane -D
      bind Left select-pane -L
      bind Right select-pane -R
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind p last-pane

      # Vim Ctrl-w style resizing windows.
      bind = select-layout -E
      bind u select-layout -o

      # Reload config without restarting tmux.
      bind C-r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

      # Alt-h / Alt-l moves between windows. Tab jumps to the last window.
      bind -n M-h previous-window
      bind -n M-l next-window
      bind Tab last-window

      # Vim-like selection inside copy mode.
      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi V send -X select-line
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi q send -X cancel

      # Disable visual bells and activity notifications.
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none
    '';
  };
}
