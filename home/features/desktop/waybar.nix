{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = [{
      layer = "top";
      output = [ "eDP-1" ];
      modules-left = [ "hyprland/workspaces" ]; # "sway/window" ];
      modules-center = [ "clock#date" "clock#time" ];
      modules-right =
        [ "memory" "cpu" "temperature" "backlight" "battery" "tray" ];
      height = 24;
      # modules = {
      #   "sway/window" = {
      #     max-length = 50;
      #   };
      battery = {
        interval = 10;
        states = {
          warning = 30;
          critical = 15;
        };

        format = "  {icon}  {capacity}%";
        "format-discharging" = "{icon}  {capacity}%";
        "format-icons" = [ "" "" "" "" "" ];
        tooltip = true;
      };
      "clock#time" = {
        interval = 1;
        format = "{:%H:%M:%S}";
        tooltip = false;
      };

      "clock#date" = {
        interval = 10;
        format = "  {:%e %b %Y}";
        "tooltip-format" = "{:%e %B %Y}";
      };
      cpu = {
        interval = 5;
        format = "  {usage}% ({load})";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      memory = {
        interval = 5;
        format = "  {}%";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      temperature = {
        "critical-threshold" = 80;
        "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
        interval = 5;
        format = "{icon}  {temperatureC}°C";
        "format-icons" = [ "" "" "" "" "" ];
        tooltip = true;
      };

      tray = {
        "icon-size" = 21;
        spacing = 10;
      };

      "hyprland/workspaces" = {
        "active-only" = false;
        "all-outputs" = true;
        "disable-scroll" = true;
        "on-click" = "activate";
        "show-special" = false;
        "format" = "{icon}";
        "format-icons" = {
          "active" = "";
          "default" = "";
          "empty" = "";
          "urgent" = "";
          "special" = "";
        };
        "persistent-workspaces" = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
          "6" = [ ];
          "7" = [ ];
          "8" = [ ];
          "9" = [ ];
          "10" = [ ];
        };
      };

      backlight = {
        device = "intel_backlight";
        format = "{icon} {percent}%";
        "format-icons" = [ "󰚵" ];
      };

    }];

    style = ''
      @keyframes blink-warning {
          70% {
              color: #dcdccc;
          }

          to {
              color: #3f3f3f;
              background-color: #f0deae;
          }
      }

      @keyframes blink-critical {
          70% {
            color: #dcdccc;
          }

          to {
              color: #3f3f3f;
              background-color: #de0030;
          }
      }

      * {
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      #waybar {
          background: #21322f;
          color: #dcdccc;
          font-family: FiraCode Nerd Font;
          font-size: 13px;
      }

      #battery,
      #clock,
      #cpu,
      #memory,
      #mode,
      #temperature,
      #tray {
          padding-left: 10px;
          padding-right: 10px;
      }


      #battery {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #battery.warning {
          color: #f0deae;
      }

      #battery.critical {
          color: #de0030;
      }

      #battery.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
      }

      #battery.critical.discharging {
          animation-name: blink-critical;
          animation-duration: 2s;
      }

      #clock {
          font-weight: bold;
      }

      #cpu {
        /* No styles */
      }

      #cpu.warning {
          color: #f0deae;
      }

      #cpu.critical {
          color: #de0030;
      }

      #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #memory.warning {
          color: #f0deae;
      }

      #memory.critical {
          color: #de0030;
          animation-name: blink-critical;
          animation-duration: 2s;
      }


      #temperature {
          /* No styles */
      }

      #temperature.warning {
          color: #f0deae
      }

      #temperature.critical {
          color: #de0030;
      }

      #tray {
          /* No styles */
      }

      #workspaces button {
          padding-left: 10px;
          padding-right: 10px;
          color: #888888;
      }

      #workspaces button.focused {
          border-color: #4c7899;
          color: white;
          background-color: #285577;
      }

      #workspaces button.urgent {
          border-color: #de0030;
          color: #de0030;
      }

      #workspaces button:hover {
        box-shadow: none;
        text-shadow: none;
        background: #3f3f3f;
        transition: none;
      }
    '';

  };
}
