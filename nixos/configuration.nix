{
  pkgs,
  ...
}:
let
  vimPkg = (
    (pkgs.vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ solarized ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''
        set relativenumber
        set number
        set cursorline
        set incsearch
        set hlsearch
        set expandtab
        syntax enable
        set background=light
        colorscheme solarized
      '';
    }
  );
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "uk_UA.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = false;
      man-db.enable = true;
    };
  };

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.niri.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.steam.enable = true;

  environment.variables = {
    EDITOR = "vim";
  };

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    vimPkg
    glibcLocalesUtf8
    glibcLocales
    qemu
    man
    man-pages
    man-pages-posix
    linux-manual
    wget
    curl
    git
    coreutils-full
    docker
  ];

  # docker
  virtualisation.docker.enable = false;

  # virtualization
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "box" ];
  virtualisation.libvirtd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  users.defaultUserShell = pkgs.fish;
  users.users.box = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "wireshark"
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
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
    bluetooth.powerOnBoot = false;

    graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs.mesa;
      package32 = pkgs.pkgsi686Linux.mesa;
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

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
  };

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/nvme0n1";
      }
    ];
  };
  services.gvfs.enable = true;

  # Enable touchpad support
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
  };

  nix.settings.auto-optimise-store = true;

  # DO NOT TOUCH
  system.stateVersion = "24.11"; # Did you read the comment?

}
