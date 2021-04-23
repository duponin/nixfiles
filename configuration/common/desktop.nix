{ config, lib, pkgs, ... }:
let czkawka = pkgs.callPackage ./czkawka.nix { };
in {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # To flash Keyboard
    libusb
    wally-cli

    # Font related pkgs
    fira
    fira-code
    fira-code-symbols
    fira-mono
    font-awesome
    hasklig
    iosevka
    nerdfonts

    # Desktop
    barrier
    bitwarden
    chromium
    czkawka
    darktable
    digikam
    element-desktop
    feh
    firefox
    gimp
    inkscape
    kdeApplications.kmail-account-wizard
    kdeApplications.kmailtransport
    kdeApplications.spectacle
    keepassxc
    kmail
    mpv
    networkmanager
    networkmanager-openvpn
    networkmanagerapplet
    ntfs3g
    obs-studio
    olive-editor
    openvpn
    plasma-integration
    scrcpy
    simplescreenrecorder
    tdesktop # Telegram
    thunderbird
    transmission-remote-gtk
    virt-manager
    vivaldi
  ];
}
