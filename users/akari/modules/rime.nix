{
  config,
  lib,
  pkgs,
  ...
}:

let
  rimeConfig = ../config/rime;
  rimeEmoji = pkgs.fetchFromGitHub {
    owner = "rime";
    repo = "rime-emoji";
    rev = "d1dbb424124fc50452a179300c7f287dbcc0db64";
    hash = "sha256-QqHauKSfyi+heseUTQ+gztjkdoSGGfw/jRorFxSiXOo=";
  };
in
{
  xdg.dataFile =
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair "fcitx5/rime/${name}" {
        # Rime uses source mtimes to decide whether compiled schemas are stale.
        # Nix store files have epoch mtimes, so link to the live checkout here.
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/akari/config/rime/${name}";
        force = true;
      }
    ) (lib.filterAttrs (_: type: type == "regular") (builtins.readDir rimeConfig))
    // {
      "fcitx5/rime/lua" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/users/akari/config/rime/lua";
        force = true;
      };
      "fcitx5/rime/opencc/emoji.json" = {
        source = "${rimeEmoji}/opencc/emoji.json";
        force = true;
      };
      "fcitx5/rime/opencc/emoji_category.txt" = {
        source = "${rimeEmoji}/opencc/emoji_category.txt";
        force = true;
      };
      "fcitx5/rime/opencc/emoji_word.txt" = {
        source = "${rimeEmoji}/opencc/emoji_word.txt";
        force = true;
      };
      "fcitx5/rime/opencc/emoji_simp.json" = {
        source = rimeConfig + "/opencc/emoji_simp.json";
        force = true;
      };
      "fcitx5/rime/opencc/emoji_simp.txt" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/iDvel/rime-ice/569ff3bc65dd4aec0a26b33c49c8bbdfa8b5fd57/opencc/emoji.txt";
          hash = "sha256-8+E5Yiie7cy+kvbUxd+X2wM1fFrZSr2tPVkQq6VWcFo=";
        };
        force = true;
      };
      "fcitx5/rime/essay-zh-hans.txt" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/rime/rime-essay-simp/dc06d4c96ae72ad46b29e3aa824a5d1e8f721fd0/essay-zh-hans.txt";
          hash = "sha256-k/wZF0P8K5tFSlzuDd4QKv7xpWb057MiifglgOTY86w=";
        };
        force = true;
      };
      "fcitx5/rime/zh-hans-t-essay-bgc.gram" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/f8ce3b534733e489a8470a7c2adf5a154e8ea069/zh-hans-t-essay-bgc.gram";
          hash = "sha256-xS3rVrFkLk9WoYkm//y0twOFgo+SG/rJLF/0BVzOU3c=";
        };
        force = true;
      };
      "fcitx5/rime/zh-hans-t-essay-bgw.gram" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/f8ce3b534733e489a8470a7c2adf5a154e8ea069/zh-hans-t-essay-bgw.gram";
          hash = "sha256-08skOMH9zWqFXdbKj1wQYKKSc8a2TCwsaa9nzXG2qn4=";
        };
        force = true;
      };
      "fcitx5/rime/zh-hant-t-essay-bgc.gram" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/97bf55046aad163c3d1881abae5312040b1bbed9/zh-hant-t-essay-bgc.gram";
          hash = "sha256-fPZNUjepLcz5010Ex27zyRlFBgOmB6OI0VbucGPwRHA=";
        };
        force = true;
      };
      "fcitx5/rime/zh-hant-t-essay-bgw.gram" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/lotem/rime-octagram-data/97bf55046aad163c3d1881abae5312040b1bbed9/zh-hant-t-essay-bgw.gram";
          hash = "sha256-BIjr1miPkAo5IA8reU8vmby/Ho/CcoCuSiMksIsVWcE=";
        };
        force = true;
      };
    };
}
