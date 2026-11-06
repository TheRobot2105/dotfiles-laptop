{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          thunderbird
          ltex-ls-plus
          qalculate-qt
          spotify
          #libreoffice
          obsidian
          qbittorrent
          kdePackages.filelight
          inkscape
          libation
          fastfetch
          fira-code
          #drawio
          vlc
          bitwarden-desktop
          age
          shfmt
          heroic
          dbeaver-bin
          #prismlauncher
          #zoom-us
          #cryptomator
          #jabref
          openscad-unstable
          just
          just-lsp
          #teamspeak6-client
          #nodejs
          #rendercv
          #radiotray-ng
          #rapid-photo-downloader
          discord
          sonarr
          radarr
          devenv
          parsec-bin
          claude-code
          jetbrains.idea
          xdg-utils
        ]
        ++ (with pkgs.stablepkgs; [
          #jabref
          #openscad-unstable
        ])
        ++ (with pkgs.nur.repos; [
          #therobot2105.vivado-2020_1
        ]);
    };
}
