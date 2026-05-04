{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        margin-left = 8;
        margin-right = 8;
        margin-top = 4;
        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "temperature" "pulseaudio" "network" "tray" "custom/notification"];
        "niri/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };
        "niri/window" = {
          format = "{title}";
          max-length = 60;
        };
        "clock" = {
          format = "{:%Y年%m月%d日  %H:%M}";
          tooltip-format = "<big>{:%Y年%m月}</big>\n<tt>{calendar}</tt>";
          locale = "zh_CN.UTF-8";
        };
        "cpu" = {
          format = " {usage}%";
          interval = 2;
        };
        "memory" = {
          format = " {percentage}%";
          interval = 10;
        };
        "temperature" = {
          format = " {temperatureC}°C";
          critical-threshold = 80;
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " 静音";
          on-click = "pavucontrol";
        };
        "network" = {
          format-wifi = " {essid}";
          format-disconnected = "⚠ 断开";
        };
        "tray" = {spacing = 6;};
      };
    };
    style = ''
      * { font-family: "Maple Mono NF", "Noto Sans CJK SC"; font-size: 13px; }
      window#waybar { background: rgba(30, 30, 46, 0.90); color: #cdd6f4; border-radius: 8px; }
      #workspaces button { padding: 2px 10px; color: #6c7086; }
      #workspaces button.active { color: #89b4fa; background: rgba(137, 180, 250, 0.15); }
      #clock { font-weight: bold; color: #89dceb; }
      #cpu, #memory, #temperature, #pulseaudio, #network, #tray {
        padding: 2px 12px; margin: 4px 2px; border-radius: 6px; background: rgba(49, 50, 68, 0.6);
      }
    '';
  };
}
