{ config, duponin, pkgs, lib, ... }:

{
  imports = [ # #
    ./hardware-configuration.nix
    ../../modules
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
    audiovisual.enable = true;
    doom-emacs.enable = true;
    shell.enable = true;
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

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;
  };
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [
      "docker" # Docker
      "libvirtd" # Virtualisation
      "networkmanager" # Network
      "wheel" # Sudo
    ];
  };
  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.duponin = {
  #     programs.git = {
  #       enable = true;
  #       package = pkgs.gitFull;
  #       userName = "Antonin Dupont";
  #       userEmail = "duponin@locahlo.st";
  #       delta.enable = true;
  #       extraConfig = { pull = { ff = "only"; }; };
  #       # signing = true;
  #     };
  #   };
  # };

  # ----------------------------------------------------------------------------
  # Wally (QMK flashing tool)
  services.udev.extraRules = ''
    # Teensy rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

    # Rule for all ZSA keyboards
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
    # Rule for the Moonlander
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
    # Rule for the Ergodox EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
    # Rule for the Planck EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
  '';

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

    # To flash Keyboard
    libusb
    wally-cli

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
