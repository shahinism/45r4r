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
              color: #ffffff;
          }

          to {
              background-color: #d0bc00;
          }
      }

      @keyframes blink-critical {
          70% {
            color: #ffffff;
          }

          to {
              background-color: #ff5f59;
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
          background: #000000;
          color: #ffffff;
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
          color: #d0bc00;
      }

      #battery.critical {
          color: #ff5f59;
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
          color: #d0bc00;
      }

      #cpu.critical {
          color: #ff5f59;
      }

      #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #memory.warning {
          color: #d0bc00;
      }

      #memory.critical {
          color: #ff5f59;
          animation-name: blink-critical;
          animation-duration: 2s;
      }


      #temperature {
          /* No styles */
      }

      #temperature.warning {
          color: #d0bc00;
      }

      #temperature.critical {
          color: #ff5f59;
      }

      #tray {
          /* No styles */
      }

      #workspaces button {
          padding-left: 10px;
          padding-right: 10px;
          color: #989898;
      }

      #workspaces button.focused {
          border-color: #00bcff;
          color: white;
          background-color: #5a5a5a;
      }

      #workspaces button.urgent {
          border-color: #ff5f59;
          color: #ff5f59;
      }

      #workspaces button:hover {
        box-shadow: none;
        text-shadow: none;
        background: #535353;
        transition: none;
      }
    '';

  };
}
