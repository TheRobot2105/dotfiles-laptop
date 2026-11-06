# Desktop-Programme, die über NixOS-Optionen statt als Paket aktiviert werden.
{ inputs, ... }:
{
  flake.modules.nixos.apps =
    { pkgs, ... }:
    {
      imports = [
        inputs.nur.modules.nixos.default
        inputs.omnibin.nixosModules.default
      ];

      programs.firefox.enable = true;
      programs.firefox.nativeMessagingHosts.packages = [
        #pkgs.jabref
      ];

      programs.localsend.enable = true;

      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs = pkgs: [
            pkgs.libpng
            pkgs.webkitgtk_4_1
          ];
        };
      };

      services.node-red.enable = false;
      services.omnibin.enable = false; # Hängt sich auf bei aktivieriung warten bis es neue Version gibt
    };
}
