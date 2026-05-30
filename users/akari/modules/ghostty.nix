{ pkgs, ... }:

let
  ghosttyTmuxSession = pkgs.writeShellScript "ghostty-tmux-session" ''
    set -eu

    tmux=${pkgs.tmux}/bin/tmux
    awk=${pkgs.gawk}/bin/awk
    sort=${pkgs.coreutils}/bin/sort
    head=${pkgs.coreutils}/bin/head

    session="$(
      "$tmux" list-sessions -F '#{session_name} #{session_attached}' 2>/dev/null \
        | "$awk" '$1 ~ /^ghostty-[0-9]+$/ && $2 == 0 { sub(/^ghostty-/, "", $1); print $1 }' \
        | "$sort" -n \
        | "$head" -n1
    )"

    if [ -z "$session" ]; then
      session="$(
        "$tmux" list-sessions -F '#{session_name}' 2>/dev/null \
          | "$awk" 'BEGIN { max = -1 } /^ghostty-[0-9]+$/ { sub(/^ghostty-/, ""); if ($0 > max) max = $0 } END { print max + 1 }'
      )"
    fi

    exec "$tmux" new-session -A -s "ghostty-$session"
  '';
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      background-blur = true;
      background-opacity = 0.85;
      command = "shell:${ghosttyTmuxSession}";
      font-family = "Iosevka Nerd Font";
      font-size = 16;
      theme = "Ayu";
    };
  };
}
