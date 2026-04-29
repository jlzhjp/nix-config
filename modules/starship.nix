{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 1000;

      character = {
        error_symbol = "[x](bold red)";
        success_symbol = "[>](bold green)";
      };

      cmd_duration = {
        min_time = 1000;
        style = "yellow";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch.symbol = "";

      git_status = {
        conflicted = "=";
        deleted = "x";
        modified = "!";
        renamed = ">";
        staged = "+";
        stashed = "$";
        untracked = "?";
      };

      nix_shell = {
        format = "via [$symbol$state( \\($name\\))]($style) ";
        symbol = "nix ";
      };

      status = {
        disabled = false;
        symbol = "exit ";
      };
    };
  };
}
