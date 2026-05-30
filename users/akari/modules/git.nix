{ config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      core.pager = "delta";
      delta.navigate = true;
      commit.gpgsign = true;
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      };
      interactive.diffFilter = "delta --color-only";
      merge.conflictStyle = "zdiff3";
      user = {
        email = "jvjdev@gmail.com";
        name = "akari";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILK9mbY23GXiMBEuoOnRFHOVQbfjbkJDMYKMy+8Jgjc2";
      };
      alias = {
        st = "status -sb";
        co = "checkout";
        sw = "switch";
        br = "branch";
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        cane = "commit --amend --no-edit";
        aa = "add -A";

        unstage = "restore --staged --";
        last = "log -1 HEAD --stat";

        lg = "log --oneline --graph --decorate --all";
        ll = "log --oneline --decorate -20";
        lga = "log --graph --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(auto)%d%Creset %s %Cgreen(%an)%Creset' --date=short --all";

        df = "diff";
        dfs = "diff --staged";
        dfh = "diff HEAD";
        dft = "difftool";

        rb = "rebase";
        rbi = "rebase -i";
        pick = "cherry-pick";
        mt = "mergetool";

        pl = "pull --ff-only";
        ps = "push";
        pf = "push --force-with-lease";

        save = "stash push -u -m";
        pop = "stash pop";
        sl = "stash list";
        sd = "stash show -p";

        undo = "reset --soft HEAD~1";
        discard = "restore --";
        wipe = "reset --hard HEAD";
        cleanall = "clean -fd";

        who = "shortlog -sn";
        root = "rev-parse --show-toplevel";
        aliases = "config --get-regexp ^alias\\.";
      };
    };
  };
}
