{
  flake.modules.nixos.virtualisation = { ... }: {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "felix" ];
    users.users.felix.extraGroups = [ "docker" ];

    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "btrfs";
      };
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
