{
  lib,
  buildGoModule,
  buildGo125Module ? null,
}:

let
  buildGo = if buildGo125Module != null then buildGo125Module else buildGoModule;
in
buildGo {
  pname = "network-auto-login";
  version = "0.1.0";

  src = ./.;
  vendorHash = null;

  meta = {
    description = "Automatic network captive portal login helper";
    mainProgram = "network-auto-login";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
