{config, pkgs, lib, inputs, ...}:
{
  home.packages = [
    pkgs.xwayland-satellite
  ];

  home.file."/home/chrx/.config/DankMaterialShell/settings.json".enable = lib.mkForce false;

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = false;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };
  
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = false;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = false;       # Calendar integration (khal)
  };
}
