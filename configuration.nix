# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{

  imports = [
    inputs.sops-nix.nixosModules.sops
    ./disko-config.nix
    #./hyprland-system.nix
    ./cachix.nix
    ./user-config/plasma-fix.nix
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      password = {
        neededForUsers = true;
      };
      age-key = {
        path = "/home/felix/.config/sops/age/keys.txt";
        owner = config.users.users.felix.name;
      };
      ssh-private-key = {
        path = "/home/felix/.ssh/id_ed25519";
        owner = config.users.users.felix.name;
      };
      ssh-public-key = {
        path = "/home/felix/.ssh/id_ed25519.pub";
        owner = config.users.users.felix.name;
      };
      syncthing-cert = {
      };
      syncthing-key = {
      };
    };
  };

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  zramSwap.enable = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nix.optimise = {
    automatic = true;
  };

  networking.hostName = "nixos-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openconnect
      networkmanager-openvpn
    ];
  };
  #networking.wireless.enable = lib.mkDefault false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.felix = {
    isNormalUser = true;
    description = "Felix Kimmel";
    hashedPasswordFile = config.sops.secrets.password.path;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  # Install firefox.
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = [
    #pkgs.jabref
  ];

  programs.kdeconnect.enable = true;

  # Allow unfree packages
  nixpkgs = {
    hostPlatform = {
      system = "x86_64-linux";
    };
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nixd
    texlive.combined.scheme-full
    git
    git-crypt
    git-lfs
    filezilla
    python312
    python312Packages.pygments
    btop-rocm
    kdePackages.partitionmanager
    exfat
    exfatprogs
    sops
    rar
    cachix
    nixfmt-tree
    yubioath-flutter
    syncthingtray
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          targetPkgs =
            pkgs:
            # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
            # lacking many basic packages needed by most software.
            # Therefore, we need to add them manually.
            #
            # pkgs.appimageTools provides basic packages required by most software.
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
              ncurses
              chromium
              python3
              # Feel free to add more packages here if needed.
            ]);
          profile = "export FHS=1";
          runScript = "bash";
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
  ];

  fonts.packages = with pkgs; [
    fira-code
    liberation_ttf
  ];
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.power-profiles-daemon.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core.udev
    openocd
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    group = "users";
    user = "felix";
    dataDir = "/home/felix/syncthing";
    configDir = "/home/felix/.config/syncthing";
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = false;
    settings = {
      devices = {
        "pCopyparty" = {
          id = "L62NXFW-4KGPXKW-XHT7VCQ-73CKJCE-D2EU666-SZW2YKC-W2UBSTW-3JZJ4QL";
        };
        "Desktop" = {
          id = "JJXJFPD-DPCLLWG-JCK5QAG-65UGLLO-PRKHRDY-BKOVMAS-HWMOMY7-AOU5NQK";
        };
        "syncthing-hetzner" = {
          id = "BOWTHBY-MEXFJQT-AWPNLE2-JWYQWL4-EXRBGQX-2U2LYAC-YI4SBEJ-UMOZAA3";
        };
      };
    };
    key = config.sops.secrets.syncthing-key.path;
    cert = config.sops.secrets.syncthing-cert.path;
  };

  services.fwupd.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "felix" ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

  };
  programs.localsend.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  home-manager.backupFileExtension = "backup";
}
