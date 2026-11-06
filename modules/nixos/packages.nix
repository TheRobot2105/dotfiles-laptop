# Allgemeine CLI-/Systemwerkzeuge ohne eigenes Feature-Modul.
{ inputs, ... }:
{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        nixd
        texliveFull
        git
        git-lfs
        filezilla
        python3
        python3Packages.pygments
        btop-rocm
        exfat
        exfatprogs
        rar
        cachix
        nixfmt-tree
        yubioath-flutter
        inputs.juliaup-nix.packages.${pkgs.stdenv.hostPlatform.system}.juliaup
      ];
    };
}
