{ pkgs, ... }:
{
  home.username = "box";
  home.homeDirectory = "/home/box";

  # DO NOT TOUCH
  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ 
    yt-dlp
    spotdl
    alsa-utils

    _7zz
    gnutar

    ripgrep-all
    ripgrep
    fzf
    coreutils-full

    ninja
    cmake
    gnumake
    python3
    gdb
    clang
    lua-language-server
    clang-tools
    tmux

    slurp
    grim
    fastfetch

    adwaita-icon-theme
    nerdfonts
    gohufont

    wine64
    ];

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
    '';

    shellAliases = {
      la = "ls -lAh --group-directories-first --color=auto";
      ls = "ls --group-directories-first --color=auto";
      cdp = "cd ~-";
      cl = "clear -x";
      so = "source";
      cdb = "cd ..";
      battery = "echo $(\cat /sys/class/power_supply/BAT1/capacity)%";
      vim = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set-option -a terminal-features 'alacritty:RGB'
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
