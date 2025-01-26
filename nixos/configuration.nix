{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  fonts.packages = with pkgs; [
    nerdfonts
    gohufont
  ];

  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty

    # development
    qemu
    qemu-utils
    gcc
    man
    man-pages
    man-pages-posix
    wget
    curl
    git
    coreutils-full
    busybox

    # browsers
    firefox
    librewolf

    # apps
    steam
    gnome-secrets
    pcmanfm
    thunderbird

    # music
    mpd-mpris
    mpc
    playerctl
    alsa-utils

    # sutff
    waybar
    brightnessctl
    wl-clipboard
    swww
    bemenu
  ];

  users.users.box = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  # MPD
  services.mpd = {
    enable = true;
    musicDirectory = "/home/box/music";
    extraConfig = ''
      		  audio_output {
      			  type "pipewire"
      			  name "My PipeWire Output"
      		  }
      	  '';
    user = "box";
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # make playerctl work with mpd
  systemd.user.services.mpd-mpris = {
    description = "MPD MPRIS Interface";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
      Restart = "on-failure";
    };
  };

  services.blueman.enable = true;

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.openssh.enable = true;

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/nvme0n1";
      }
    ];
  };

  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
  };

  # DO NOT TOUCH
  system.stateVersion = "24.11"; # Did you read the comment?

}
