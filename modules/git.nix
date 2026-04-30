{
  programs.git = {
    enable = true;
    settings = {
      core.pager = "delta";
      delta.navigate = true;
      interactive.diffFilter = "delta --color-only";
      merge.conflictStyle = "zdiff3";
      user = {
        name = "akari";
        email = "jvjdev@gmail.com";
      };
    };
  };
}
