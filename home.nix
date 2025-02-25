{
  pkgs,
  ...
}:

let
  nvimConfig = import ./configs/nvim_config.nix {};
  waybarConfig = import ./configs/waybar_config.nix;
  hyprlandConfig = import ./configs/hyprland_config.nix;
in
{
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
  home.username = "box";
  home.homeDirectory = "/home/box";

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        variant = "latte";
        size = "compact";
      };
      name = "catppuccin-latte-lavender-compact";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "GohuFont";
      size = 11;
    };

    gtk4.extraCss = ''* { font-weight: bold; }'';
    gtk3.extraCss = ''* { font-weight: bold; }'';
  };

  catppuccin = {
    flavor = "latte";
    accent = "lavender";
    fish.enable = true;
    alacritty.enable = true;
    waybar.enable = true;
    hyprland.enable = true;
  };

  programs.firefox.enable = true;
  programs.librewolf.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
    extraConfig = hyprlandConfig.config;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      nvim-treesitter.withAllGrammars
      vim-airline
      plenary-nvim
      telescope-nvim
      vim-fugitive
      undotree
      vim-slime
      catppuccin-nvim
      nvim-dap
    ];
    extraLuaConfig = nvimConfig.config;
    vimAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
  };

  programs.waybar = {
    enable = true;
    style = waybarConfig.style;
    settings.mainBar = waybarConfig.config;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dynamic_padding = true;
        opacity = 0.95;
        blur = false;
      };
      general = {
        live_config_reload = true;
      };
      font = {
        normal = {
          family = "GohuFont";
          style = "Bold";
        };
        italic = {
          family = "GohuFont";
          style = "Bold";
        };
        bold = {
          family = "GohuFont";
          style = "Bold";
        };
        size = 11;
      };
      mouse = {
        hide_when_typing = true;
      };
    };
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
    rofi
    fastfetch
    yt-dlp
    spotdl

    # music
    mpd-mpris
    mpc
    playerctl
    alsa-utils

    # DEVELOPMENT
    clang-manpages
    parallel-full
    _7zz
    gnutar
    ripgrep
    fzf
    valgrind

    # build systems
    ninja
    cmake
    gnumake
    autoconf
    automake
    cabal-install
    stack

    # compilers, interpreters, debuggers ...
    lld
    libllvm
    clang
    ghc
    python39
    lua
    gdb
    lldb
    haskellPackages.haskell-debug-adapter
    haskellPackages.ghci-dap

    # lsps
    nixfmt-rfc-style
    nixd
    clang-tools
    lua-language-server
    haskell-language-server

    # misc
    adwaita-icon-theme
    wine64
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
      vim = "nvim";
    };
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
