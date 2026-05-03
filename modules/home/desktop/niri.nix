{ config, pkgs, ... }:

{
  programs.niri.settings = {
    outputs = {
      "DP-2" = {
        enable  = true;
        mode    = { width = 2560; height = 1080; refresh = 60.000; };
        scale   = 1.0;
        position = { x = 0; y = 0; };
      };
    };

    input = {
      keyboard = {
        xkb = { layout = "us"; options = "caps:escape"; };
        repeat-delay = 250;
        repeat-rate = 50;
      };
      mouse = { accel-speed = 0.0; accel-profile = "flat"; };
    };

    layout = {
      gaps = 8;
      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5;     }
        { proportion = 0.66667; }
        { proportion = 1.0;     }
      ];
      default-column-width = { proportion = 0.5; };
      border = {
        enable = true;
        width  = 2;
        active-color   = "#89b4fa";
        inactive-color = "#45475a";
      };
      shadow = {
        enable = true;
        offset = { x = 0; y = 4; };
        softness = 20;
        color = "rgba(0, 0, 0, 60%)";
      };
    };

    animations = {
      slowdown = 1.0;
      window-open-anim    = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
      window-close-anim   = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
      horizontal-view-movement = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
      window-movement-throttle = { spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; }; };
    };

    binds = with config.lib.niri.actions; let
      mod = "Super";
    in {
      "${mod}+Return".action        = spawn "ghostty";
      "${mod}+Space".action         = spawn "fuzzel";
      "${mod}+E".action             = spawn "nautilus";
      "${mod}+B".action             = spawn "google-chrome-stable";
      "${mod}+Q".action             = close-window;
      "${mod}+F".action             = maximize-column;
      "${mod}+Shift+F".action       = fullscreen-window;
      "${mod}+C".action             = center-column;
      "${mod}+H".action             = focus-column-left;
      "${mod}+L".action             = focus-column-right;
      "${mod}+J".action             = focus-window-down;
      "${mod}+K".action             = focus-window-up;
      "${mod}+Shift+H".action       = move-column-left;
      "${mod}+Shift+L".action       = move-column-right;
      "${mod}+Shift+J".action       = move-window-down;
      "${mod}+Shift+K".action       = move-window-up;
      "${mod}+1".action             = focus-workspace 1;
      "${mod}+2".action             = focus-workspace 2;
      "${mod}+3".action             = focus-workspace 3;
      "${mod}+4".action             = focus-workspace 4;
      "${mod}+5".action             = focus-workspace 5;
      "${mod}+6".action             = focus-workspace 6;
      "${mod}+Shift+1".action       = move-window-to-workspace 1;
      "${mod}+Shift+2".action       = move-window-to-workspace 2;
      "${mod}+Shift+3".action       = move-window-to-workspace 3;
      "${mod}+Shift+4".action       = move-window-to-workspace 4;
      "${mod}+R".action             = switch-preset-column-width;
      "${mod}+Minus".action         = set-column-width "-5%";
      "${mod}+Equal".action         = set-column-width "+5%";
      "${mod}+Shift+Minus".action   = set-window-height "-5%";
      "${mod}+Shift+Equal".action   = set-window-height "+5%";
      "Print".action                = screenshot;
      "${mod}+Print".action         = screenshot-window;
      "${mod}+Shift+S".action       = screenshot-screen;
      "${mod}+Shift+E".action       = quit;
      "${mod}+Shift+R".action       = reload-config;
      "XF86AudioRaiseVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
      "XF86AudioLowerVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "XF86AudioMute".action         = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "XF86AudioPlay".action         = spawn "playerctl" "play-pause";
      "XF86AudioNext".action         = spawn "playerctl" "next";
      "XF86AudioPrev".action         = spawn "playerctl" "previous";
    };

    spawn-at-startup = [
      { command = [ "fcitx5" "-d" "--replace" ]; }
      { command = [ "mako" ]; }
      { command = [ "waybar" ]; }
      { command = [ "swww-daemon" ]; }
      { command = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]; }
    ];

    window-rules = [
      {
        matches = [
          { app-id = "org.gnome.Nautilus"; title = "Properties"; }
          { app-id = "pavucontrol"; }
          { app-id = "nm-connection-editor"; }
          { app-id = "fcitx5-config"; }
        ];
        open-floating = true;
      }
      {
        matches = [{ app-id = "google-chrome"; title = "画中画"; }];
        open-floating = true;
      }
    ];
  };
}
