{ config, pkgs, hostname, ... }:
{
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  hardware.firmware = [
    pkgs.sof-firmware
  ];
  hardware.sensor.iio.enable = hostname == "nyx";
  services.tlp.enable = hostname == "nyx";
  services.acpid = {
    enable = true;
    handlers.TBLT = {
      event = "video/tabletmode";
      action = ''
        vals=($1)
        case ''${vals[2]} in
          0000008A)
            case ''${vals[3]} in
              00000001)
                echo "Tablet mode enabled"
                echo "activated" >> /var/run/user/1000/tablet
                disabled=1
                ;;
              00000000)
                echo "Tablet mode disabled"
                echo "deactivated" >> /var/run/user/1000/tablet
                disabled=0
                ;;
              *)
                echo "ACPI action undefined: $1" ;;
              esac
            ;;
          *)
            echo "ACPI action undefined: $1" ;;
          esac
          find /sys/class/input/input* -prune | while read inputnumber; do
            if grep -q -i -e "keyboard" -e "touchpad" $inputnumber/name; then
              echo "found $(cat $inputnumber/name)";
              echo $disabled > $inputnumber/inhibited;
            fi
          done
      '';
    };
  };
}
