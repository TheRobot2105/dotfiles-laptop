{ config, pkgs, ... }:

{
  # Accept Android SDK license
  nixpkgs.config.android_sdk.accept_license = true;

  # Install Android Studio
  environment.systemPackages = with pkgs; [
    android-studio
    jdk17 # To be able to export JAVA_HOME, if not using android-studio-full
  ];

  # Enable ADB
  programs.adb.enable = true;

  # Add your user to necessary groups
  users.users.felix.extraGroups = [
    "adbusers"
    "kvm"
  ];

  # Above configuration without jdk17 package is enough to run Android Studio.
  # However, to be able to run android projects and AVDs outside Android Studio,
  # we need to export SDK and JDK environment variables so we can use them externally.
  # If not using android-studio-full package;
  # we need jdk17 package to be able to export JAVA_HOME, also, nix-ld configuration.
  # We can use the SDK of android-studio package but NixOS doesn't accept that; Sdk
  # exports don't work since it is not installed from nix packages,
  # it is installed on the first launch of Android Studio. However, there is a
  # workaround; nix-ld configuration help us run external packages on NixOS
  # ( Android Sdk in our case ).
  # It is said that android-studio-full package includes full Sdk.
  # Exporting Sdk and jdk environment variables would work directly,
  # we wouldn't need nix-ld config; Sdk export variables would be accepted by NixOS,
  # Download size of android-studio-full package is about 27GB as of 2026January
  # https://wiki.nixos.org/wiki/Android#Android_Studio

  # Set Android environment variables system-wide
  environment.variables = {
    ANDROID_HOME = "$HOME/.android/Android/Sdk";
    ANDROID_SDK_ROOT = "$HOME/.android/Android/Sdk";
    JAVA_HOME = "${pkgs.jdk17}"; # <-- Point to the Nix-provided JDK
  };

  # Dynamically linked executables: ANDROID_HOME, ANDROID_SDK_ROOT
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core C++ runtime (most critical for adb)
    stdenv.cc.cc.lib

    # Compression (adb uses zlib heavily)
    zlib

    # Terminal/console support
    # ncurses

    # USB device access
    # udev

    # Graphics (emulators, SDK tools)
    # libGL
    # libGLU

    # Networking/file access
    # openssl

    # Common utils
    # libuuid
    # dbus.lib

    # 32-bit support (if using older SDKs)
    # gcc.cc.lib32 # uncomment if needed
  ];
}
