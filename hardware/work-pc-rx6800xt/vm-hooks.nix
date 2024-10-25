{ pkgs, user-info, ... }:
{
  # https://github.com/materusPL/nixos-config/tree/8327d4cfd30e77cf6a072dcb09e4eac5332554ab/configurations/host/materusPC/vm/win-vfio
  # https://github.com/GitBanan/PersonalNixConfig/blob/b65b6af6146f89a5d76d8148acf8166158ced9c0/hosts/common/optional/passthrough.nix
  virtualisation.libvirtd.hooks.qemu =
    let
      # pci_gpu_video = "pci_0000_2d_00_0";
      # pci_gpu_audio = "pci_0000_2d_00_1";
      pci_gpu_video = "0000:2d:00.0";
      pci_gpu_audio = "0000:2d:00.1";

      prepare-begin-hook = ''
        # Unbind VTconsoles
        echo 0 > /sys/class/vtconsole/vtcon0/bind
        echo 0 > /sys/class/vtconsole/vtcon1/bind

        # Stop plasma wayland
        systemctl stop display-manager.service
        killall gdm-x-session

        sleep 5

        # Start default network
        # virsh net-start default

        # Unbind EFI Framebuffer
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        # Unload AMDGPU drivers
        modprobe -r drm_kms_helper
        modprobe -r amdgpu
        modprobe -r radeon
        modprobe -r drm

        # Detach GPU from host
        # virsh nodedev-detach ${pci_gpu_video}
        # virsh nodedev-detach ${pci_gpu_audio}

        sleep 5

        # Load VFIO pci driver
        modprobe vfio
        modprobe vfio_pci
        modprobe vfio_iommu_type1

        # UNBIND DEVICES
        echo ${pci_gpu_video} > /sys/bus/pci/devices/${pci_gpu_video}/driver/unbind
        echo ${pci_gpu_audio} > /sys/bus/pci/devices/${pci_gpu_audio}/driver/unbind

        # OVERRIDE DRIVER WITH VFIO
        echo "vfio-pci" > /sys/bus/pci/devices/${pci_gpu_video}/driver_override
        echo "vfio-pci" > /sys/bus/pci/devices/${pci_gpu_audio}/driver_override

        # BIND DEVICES TO VFIO
        echo ${pci_gpu_video} > /sys/bus/pci/drivers/vfio-pci/bind
        echo ${pci_gpu_audio} > /sys/bus/pci/drivers/vfio-pci/bind
      '';

      release-end-hook = ''
        # Stop default network
        # virsh net-destroy default

        # Unload VFIO kernel modules
        modprobe -r vfio_pci
        modprobe -r vfio_iommu_type1
        modprobe -r vfi

        # Reattach GPU TO host
        # virsh nodedev-reattach ${pci_gpu_video}
        # virsh nodedev-reattach ${pci_gpu_audio}

        # UNBIND VFIO
        echo ${pci_gpu_video} > /sys/bus/pci/drivers/vfio-pci/unbind
        echo ${pci_gpu_audio} > /sys/bus/pci/drivers/vfio-pci/unbind

        # RESET DRIVER OVERRIDE
        echo > /sys/bus/pci/devices/${pci_gpu_video}/driver_override
        echo > /sys/bus/pci/devices/${pci_gpu_audio}/driver_override

        # BIND DEVICES TO ORIGINAL DRIVERS
        echo ${pci_gpu_video} > /sys/bus/pci/drivers/amdgpu/bind
        echo ${pci_gpu_audio} > /sys/bus/pci/drivers/snd_hda_intel/bind

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

        log() {
          GUEST_NAME=''$1
          LOG_FILE=''$2
          MESSAGE=''$3
          if [[ ''$GUEST_NAME =~ "logging" ]]; then
              LOG_FILE_PATH=''$(dirname ''$LOG_FILE)
              mkdir -p ''$LOG_FILE_PATH
              echo ''$MESSAGE >> ''$LOG_FILE
          fi
        }

        GUEST_NAME=''$1
        OP=''$2
        SUB_OP=''$3
        LOG_FILE="/home/${user-info.name}/my-space/vm-logs/''$GUEST_NAME"

        log ''$GUEST_NAME ''$LOG_FILE "''$OP-''$SUB_OP"

        if [[ ''$GUEST_NAME =~ "gpu-pass" ]]; then
          if [ ''$OP = "prepare" ] && [ ''$SUB_OP = "begin" ]; then
            log ''$GUEST_NAME ''$LOG_FILE " - gpu-path-prepare-begin-hook"
            ${prepare-begin-hook}
            log ''$GUEST_NAME ''$LOG_FILE " - gpu-path-prepare-begin-hook-finished"
          fi

          if [ ''$OP = "release" ] && [ ''$SUB_OP = "end" ]; then
            log ''$GUEST_NAME ''$LOG_FILE " - gpu-path-release-end-hook"
            ${release-end-hook}
            log ''$GUEST_NAME ''$LOG_FILE " - gpu-path-release-end-hook-finished"
          fi
        fi
      '';
    };
}
