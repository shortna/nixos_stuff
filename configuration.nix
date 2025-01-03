# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
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
    terminus-nerdfont
  ];

  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
    gcc
    man 
    man-pages
    man-pages-posix
# terminal utils
    alacritty
    wget
    curl
# browsers
    firefox
    librewolf
# apps
    steam
    gnome-secrets
    pcmanfm
    thunderbird
# utils
    mpd-mpris
    waybar
    git
    mpc
    playerctl
    brightnessctl
    wl-clipboard
    swww
    bemenu
  ];

  users.users.box = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
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
    touchpad.tapping = false;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # DO NOT TOUCH
  system.stateVersion = "24.11"; # Did you read the comment?
}

