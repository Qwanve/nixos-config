{config, pkgs, inputs, catppuccin, ...} :
{
  home.packages = [
    
  ];
  programs.plasma = {
    enable = true;
    # hotkeys.commmands."launch-console" = {
    #   name = "Launch Console";
    #   key = "Meta+Enter";
    #   command = "konsole";
    # };
    panels = [
      {
        location = "right";
        alignment = "center";
        widgets = [
          {
            iconTasks = {
                launchers = [];
            };
          }
          "org.kde.plasma.kickoff"
        ];
        hiding = "windowsgobelow";
        lengthMode = "fit";
        floating = true;
      }
      {
        location = "bottom";
        alignment = "left";
        widgets = [
          "org.kde.plasma.pager"
        ];
        hiding = "dodgewindows";
        lengthMode = "fit";
        floating = true;
      }
      {
        location = "top";
        alignment = "left";
        widgets = [
          "org.kde.plasma.mediacontroller"
        ];
        hiding = "dodgewindows";
        lengthMode = "fit";
        floating = true;
      }
      {
        location = "bottom";
        alignment = "right";
        widgets = [
          "org.kde.plasma.battery"
          "org.kde.plasma.brightness"
          "org.kde.plasma.audiovolume"
          "org.kde.plasma.marginsseparator"
          {
            digitalClock = {
              time.format = "24h";
              date.format = "isoDate";
            };
          }
        ];
        lengthMode = "fit";
        hiding = "dodgewindows";
        floating = true;
      }
    ];

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kwinrc.Desktops.Number = {
        value = 6;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
    };
  };
}
