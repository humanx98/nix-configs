{ config, pkgs, user-info, vm-hooks-module, ... }:

let 
  start-virsh = pkgs.writeShellScriptBin "start-virsh" ''
    sudo virsh net-list --all
    sudo virsh net-autostart default
    sudo virsh net-start default
  '';
in {

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;
  # Add user to libvirtd group
  users.users.${user-info.name}.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme
    start-virsh
  ];

  # https://kilo.bytesize.xyz/gpu-passthrough-on-nixos
  # https://github.com/materusPL/nixos-config/blob/8327d4cfd30e77cf6a072dcb09e4eac5332554ab/configurations/host/materusPC/hardware/boot.nix
  # boot = {
  #   kernelModules = [ "amdgpu" "kvm-amd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  #   kernelParams = [ "amd_iommu=on" "iommu=pt" "kvm.ignore_msrs=1" ];
  # };

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        runAsRoot = true;
        package = pkgs.qemu_full;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
  };
  imports = [ vm-hooks-module ];

  services.spice-vdagentd.enable = true;

}
