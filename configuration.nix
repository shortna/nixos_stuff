{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home-manager.nix
    ];

  boot.loader.systemd-boot.enable = true

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.box = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
  };

  environment.systemPackages = with pkgs; [
    gcc
# window manager
    hyprland
    waybar
# terminal utils
    alacritty
    neovim
    wget
    curl
# browsers
    firefox
    librewolf
# apps
    steam
    pcmanfm
    authenticator
    thunderbird
# utils
    git
    playerctl
    brightnessctl
    wl-clipboard
    swww
    bemenu
  ];

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/box/music";
# FIXME: change name of an output
    extraConfig = ''
      audio_output {
        type "pipewire"
          name "My PipeWire Output"
      }
    '';
  };

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/nvme0"; # FIXME: Potentionaly change this
      }
    ];
  };

  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  # DO NOT TOUCH
  system.copySystemConfiguration = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
