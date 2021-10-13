{ config, duponin, pkgs, lib, ... }:

{
  imports = [ # #
    ./hardware-configuration.nix
    ../../modules
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "katyusha";
  networking.interfaces.enp6s0.useDHCP = true;

  system.stateVersion = "20.09";

  # Mount /tmp on tmpfs at boot
  boot.tmpOnTmpfs = true;

  # Have same layout in TTY than in X (bepo)
  console.useXkbConfig = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # English but date is YYYY/MM/DD
  i18n.defaultLocale = "en_GB.UTF-8";

  networking = {
    networkmanager = {
      enable = true;
      dns = "default";
    };
    useDHCP = false;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  duponin = {
    android.enable = true;
    apple.enable = true;
    audiovisual.enable = true;
    doom-emacs.enable = true;
    flakes.enable = true;
    home-manager.enable = true;
    shell.enable = true;
    zsa.enable = true; # Ergodox etc.
  };

  programs = {
    gnupg = {
      package = pkgs.gnupg;
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "qt";
      };
    };
    ssh.startAgent = false;
  };

  services = {
    openssh.enable = true;
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
    printing.enable = true;
    pcscd.enable = true;
    udev.packages = [ pkgs.libu2f-host pkgs.yubikey-personalization ];
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      videoDrivers = [ "nvidia" ];
      enable = true;
      layout = "fr";
      xkbVariant = "bepo";
    };
  };

  sound.enable = true;

  time.timeZone = "Europe/Paris";

  users.mutableUsers = false;
  users.users.root.hashedPassword = "";
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [
      "docker" # Docker
      "libvirtd" # Virtualisation
      "networkmanager" # Network
      "wheel" # Sudo
    ];
    hashedPassword =
      "$6$rounds=1000000$3P.QolTKfoKz$UOXByJQfwNJJ5M7ChL.A4hlnuNiBX01/j/dHBLOy6vuN6OxJJ/fSF2x0vgpD1ZnvsKTse6V6N.z3b9.4h9WOQ0";
  };

  # ----------------------------------------------------------------------------
  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Various tools
    bat
    curl
    direnv
    dnsutils
    htop
    jq
    mkpasswd
    mtr
    multimarkdown
    mupdf
    ncdu
    nixfmt
    nmap
    pandoc
    # pinentry-qt
    rlwrap
    shellcheck
    tcpdump
    thefuck
    tldr
    tmate
    tmux
    vim
    wget
    whois
    xclip
    xsel
    yadm

    # Font related pkgs
    fira
    fira-code
    fira-code-symbols
    # fira-mono # Causing collision with Fira
    font-awesome
    hasklig
    iosevka
    nerdfonts

    # Desktop
    alacritty
    audacity
    barrier
    bitwarden
    chromium
    czkawka
    darktable
    element-desktop
    feh
    firefox
    inkscape
    libsForQt5.kmail-account-wizard
    libsForQt5.kmailtransport
    libsForQt5.spectacle
    keepassxc
    kmail
    mpv
    networkmanager
    networkmanager-openvpn
    networkmanagerapplet
    ntfs3g
    oneko
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
