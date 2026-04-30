_:

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

    extraConfig = ''
      set -g renumber-windows on
      set -g set-clipboard on

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
      bind H if -F "#{pane_at_left}" "" "move-pane -bh -t '{top-left}'"
      bind J if -F "#{pane_at_bottom}" "" "move-pane -v -t '{bottom-right}'"
      bind K if -F "#{pane_at_top}" "" "move-pane -bv -t '{top-left}'"
      bind L if -F "#{pane_at_right}" "" "move-pane -h -t '{bottom-right}'"

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
      bind t select-pane -t "{top-left}"
      bind b select-pane -t "{bottom-right}"

      # Vim Ctrl-w style resizing windows.
      bind = select-layout -E
      bind u select-layout -o
      bind _ resize-pane -y 100%
      bind | resize-pane -x 100%
      bind -r > resize-pane -x "#{e|+:#{pane_width},5}"
      bind -r < resize-pane -x "#{e|-:#{pane_width},5}"
      bind -r - resize-pane -y "#{e|-:#{pane_height},5}"
      bind -r + resize-pane -y "#{e|+:#{pane_height},5}"

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

      bind z resize-pane -Z
      bind X kill-window
      bind $ command-prompt -I "#S" "rename-session '%%'"
      bind , command-prompt -I "#W" "rename-window '%%'"

      # Disable visual bells and activity notifications.
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      setw -g clock-mode-colour brightblue
      setw -g mode-style 'fg=brightwhite bg=blue bold'

      set -g pane-border-style 'fg=blue'
      set -g pane-active-border-style 'fg=brightcyan bold'

      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=brightblue bg=default'

      set -g status-left ""
      set -g status-left-length 10

      set -g status-right-style 'fg=black bg=brightcyan bold'
      set -g status-right '%Y-%m-%d %H:%M '
      set -g status-right-length 50

      setw -g window-status-current-style 'fg=brightwhite bg=blue bold'
      setw -g window-status-current-format ' #I #W #F '

      setw -g window-status-style 'fg=blue bg=default'
      setw -g window-status-format ' #I #[fg=default]#W #[fg=brightblue]#F '

      setw -g window-status-bell-style 'fg=black bg=brightcyan bold'

      set -g message-style 'fg=brightwhite bg=blue bold'
    '';
  };
}
