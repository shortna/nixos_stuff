{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.box = {
    home.stateVersion = "18.09";
  };

  home.packages = with pkgs; [ 
    yt-dlp
    spotdl
    cmus
    alsa-utils

    _7zz
    gnutar

    ripgrep-all
    coreutils-full
    slurp
    grim

    python3
    gdb
    clang
    clang-tools
  ];
}
