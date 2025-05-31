{
  pkgs,
  ...
}:
let
  font_name = "JetBrainsMono Nerd Font Mono";
  waybar = import ./configs/waybar_config.nix { inherit font_name; };
  hyprland = import ./configs/hyprland_config.nix { };
in
{
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
  home.username = "box";
  home.homeDirectory = "/home/box";

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = font_name;
      size = 11;
    };

    gtk4.extraCss = ''* { font-weight: normal; }'';
    gtk3.extraCss = ''* { font-weight: normal; }'';
  };

  programs.firefox.enable = true;
  programs.librewolf.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = hyprland.config;
  };

  programs.waybar = {
    enable = true;
    style = waybar.style;
    settings.mainBar = waybar.config;
  };

  programs.kitty = {
    enable = true;
    font = { name = font_name; size = 11; };
    themeFile = "Solarized_Light";
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = 2;
      copy_on_select = "no";
    };
  };

  programs.bemenu.enable = true;
  programs.zoxide = {
     enable = true;
     enableFishIntegration= true;
     options = [ "--cmd j" ];
  };
  home.packages = with pkgs; [
    # apps
    steam
    gnome-secrets
    pcmanfm
    thunderbird

    # sutff
    brightnessctl
    wl-clipboard
    swww
    slurp
    grim
    fastfetch
    yt-dlp
    spotdl

    # music
    mpd-mpris
    mpc
    playerctl
    alsa-utils

    # utils
    parallel-full
    _7zz
    gnutar
    ripgrep
    fzf

    # misc
    adwaita-icon-theme
    lutris-free
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -U fish_prompt_pwd_dir_length 0
      fish_config prompt choose informative_vcs
      fish_vi_key_bindings
    '';

    shellAliases = {
      la = "ls -lAh --group-directories-first --color=auto";
      ls = "ls --group-directories-first --color=auto";
      cdp = "cd -";
      scd = "fzf-cd-widget";
      cl = "clear -x";
      so = "source";
      cdb = "cd ..";
      battery = "echo $(\cat /sys/class/power_supply/BAT1/capacity)%";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set-option -sa terminal-overrides ",xterm-kitty:RGB"

      set -g history-limit 65536

      set -g prefix C-j

      set -g mouse on
      set -g mode-keys vi
      set -g base-index 1
      set -g renumber-windows on
      set -g set-clipboard external

      set -g status "on"
      set -g status-keys vi

      set -g status-style bg=colour5,fg=colour7
      set -g message-style bg=colour5,fg=colour7
      set -g message-command-style bg=colour5,fg=colour7
      set-window-option -g mode-style bg=colour5,fg=colour7

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      bind-key -T copy-mode-vi 'Escape' send -X clear-selection

      set -sg escape-time 10
      set -g focus-events on
    '';
  };
}
