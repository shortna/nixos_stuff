{ font_name }:
{
  inherit font_name;
  style = ''
    * {
      font-family: "${font_name}";
      font-size: 11pt;
      color: @text;
      border-radius: 10px;
    }

    window#waybar {
      all:unset;
    }

    .modules-left, 
    .modules-center, 
    .modules-right {
      background: @base;
    }

    .modules-center,
    .modules-right {
      padding: 0px 5px 0px 5px;
    }

    #workspaces button.active {
      background-color: @lavender;
    }

    #custom-arrow {
      color:  @lavender;
    }
  '';

  config = {
    position = "top";
    width = 1900;
    spacing = 4;
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "mpd" ];
    fixed-center = false;
    modules-right = [
      "cpu"
      "custom/arrow"
      "memory"
      "custom/arrow"
      "backlight"
      "custom/arrow"
      "hyprland/language"
      "custom/arrow"
      "battery"
      "custom/arrow"
      "clock"
    ];

    margin-top = 5;

    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      format = "{name}";
      format-icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "10";
      };
    };

    "hyprland/language" = {
      format = "lang: {}";
      keyboard-name = "at-translated-set-2-keyboard";
    };

    "mpd" = {
      format = "{title} ({elapsedTime:%H:%M:%S}/{totalTime:%H:%M:%S})";
      format-disconnected = "Disconnected";
      unknown-tag = "N/A";
      interval = 2;
      tooltip = false;
    };

    "clock" = {
      timezone = "Europe/Kyiv";
      format = "{:%H:%M > %d/%m/%y}";
      tooltip = false;
    };

    "cpu" = {
      format = "cpu: {usage}%";
      tooltip = false;
      interval = 3;
    };

    "memory" = {
      format = "mem: {percentage}%";
      interval = 3;
    };

    "backlight" = {
      device = "amdgpu_bl0";
      format = "light: {percent}%";
    };

    "battery" = {
      bat = "BAT1";
      format = "battery: {capacity}%";
    };

    "custom/arrow" = {
      format = "|";
      tooltip = false;
    };
  };
}
