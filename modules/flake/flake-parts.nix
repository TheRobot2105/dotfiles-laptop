# Grundgerüst für flake-parts im Dendritic Pattern.
# Jede .nix-Datei unter ./modules ist ein flake-parts-Modul und wird
# automatisch über import-tree geladen (Dateien/Ordner mit "_"-Präfix ausgenommen).
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [ "x86_64-linux" ];

  # Macht die flake-parts-Optionen für nixd sichtbar (Output `debug`).
  debug = true;

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
