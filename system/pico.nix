{config, pkgs, ...}:
{
  services.udev.extraRules = ''
    ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE:="0666"
  '';

  fileSystems."/pico" = {
    device = "/dev/disk/by-id/usb-RPI_RP2_E0C9125B0D9B-0:0-part1";
    fsType = "vfat";
    options = [
      "users"
      "sync"
      "nofail"
      "noauto"
      "noatime"
    ];
  };
}
