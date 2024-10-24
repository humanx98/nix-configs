{ pkgs, user-info, ... }:
{
  # https://github.com/materusPL/nixos-config/tree/8327d4cfd30e77cf6a072dcb09e4eac5332554ab/configurations/host/materusPC/vm/win-vfio
  # https://github.com/GitBanan/PersonalNixConfig/blob/b65b6af6146f89a5d76d8148acf8166158ced9c0/hosts/common/optional/passthrough.nix
  virtualisation.libvirtd.hooks.qemu =
    let
      pci_gpu_video = "pci_0000_2d_00_0";
      pci_gpu_audio = "pci_0000_2d_00_1";

      prepare-begin-hook = ''
        # Unbind VTconsoles
        echo 0 > /sys/class/vtconsole/vtcon0/bind
        echo 0 > /sys/class/vtconsole/vtcon1/bind

        # Stop plasma wayland
        systemctl stop display-manager.service
        killall gdm-x-session

        sleep 5

        # Start default network
        virsh net-start default

        # Unbind EFI Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        # Unload AMDGPU drivers
        modprobe -r drm_kms_helper
        modprobe -r amdgpu
        modprobe -r radeon
        modprobe -r drm

        # Detach GPU from host
        virsh nodedev-detach ${pci_gpu_video}
        virsh nodedev-detach ${pci_gpu_audio}

        sleep 5

        # Load VFIO pci driver
        modprobe vfio
        modprobe vfio_pci
        modprobe vfio_iommu_type1
      '';

      release-end-hook = ''
        # Stop default network
        virsh net-destroy default

        # Unload VFIO kernel modules
        modprobe -r vfio_pci
        modprobe -r vfio_iommu_type1
        modprobe -r vfi

        # Reattach GPU TO host
        virsh nodedev-reattach ${pci_gpu_video}
        virsh nodedev-reattach ${pci_gpu_audio}

        sleep 5

        # Load AMDGPU kernel module
        modprobe drm
        modprobe amdgpu
        modprobe radeon
        modprobe drm_kms_helper

        sleep 5

        # Bind VTconsoles
        echo 1 > /sys/class/vtconsole/vtcon0/bind
        echo 1 > /sys/class/vtconsole/vtcon1/bind

        # Bind EFI Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

        # Start display manager service
        systemctl restart display-manager.service
      '';
    in
    {
      "gpu-pass" = pkgs.writeShellScript "gpu-pass.sh" ''
        GUEST_NAME=''$1
        OP=''$2
        SUB_OP=''$3
        # echo "''$1_''$2_''$3" > /home/${user-info.name}/''$1_''$2_''$3

        if [[ ''$GUEST_NAME =~ "gpu-pass" ]]; then
          if [ ''$OP = "prepare" ] && [ ''$SUB_OP = "begin" ]; then
            # echo "prepare-begin-hook" > /home/${user-info.name}/prepare-begin-hook
            ${prepare-begin-hook}
            # echo "prepare-begin-hook-finished" > /home/${user-info.name}/prepare-begin-hook-finished
          fi

          if [ ''$OP = "release" ] && [ ''$SUB_OP = "end" ]; then
            # echo "release-end-hook" > /home/${user-info.name}/release-end-hook
            ${release-end-hook}
            # echo "release-end-hook-finished" > /home/${user-info.name}/release-end-hook-finished
          fi
        fi
      '';
    };
}
