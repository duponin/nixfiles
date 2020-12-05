# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://bugzilla.kernel.org/show_bug.cgi?id=110941
  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
  };

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = {
    root = {
      device =
        "/dev/disk/by-id/nvme-WDC_PC_SN730_SDBQNTY-512G-1001_193594450508-part2";
      preLVM = true;
      allowDiscards = true;
    };
  };

  # Mount /tmp on tmpfs at boot
  boot.tmpOnTmpfs = true;

  networking.hostName = "rilakkuma"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "default";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Dev related pkgs
    docker
    elixir
    emacs
    exiftool
    cmake
    fd
    gcc
    inotify-tools
    jq
    multimarkdown
    nixfmt
    nodePackages.js-beautify
    nodePackages.npm
    nodejs
    ripgrep
    ripgrep-all
    shellcheck
    terraform
    vagrant
    xclip

    # Font related pkgs
    fira-code
    fira-code-symbols
    font-awesome
    hasklig
    iosevka
    nerdfonts

    # CLI orliented related pkgs
    bat
    dnsutils
    git
    gitAndTools.delta
    gnupg
    home-manager
    htop
    mtr
    ncdu
    pandoc
    pinentry
    pinentry-qt
    thefuck
    tldr
    tmate
    vim
    wget
    xsel
    yadm

    # Shell related pkgs
    zsh
    oh-my-zsh
    zsh-completions
    zsh-you-should-use
    zsh-syntax-highlighting
    nix-zsh-completions

    # Desktop Environment
    plasma-integration
    kdeApplications.spectacle
    transmission-remote-gtk

    # Image and video related
    digikam
    feh
    gimp
    obs-studio

    #chrome
    chromium
    firefox
    keepassxc
    tdesktop
    thunderbird

    openvpn
    networkmanager
    networkmanagerapplet
    networkmanager-openvpn

    kmail
    kdeApplications.kmail-account-wizard
    kdeApplications.kmailtransport

    barrier

    qemu
    qemu_kvm
    libvirt
    virt-manager
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    24800 # Barrier (Software KVM)
    8000 # Webserver to easily share files
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # To communinicate with Android devices
  programs.adb.enable = true;

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host all all 127.0.0.1/32 trust
    '';
  };

  # Ergodox udev rules
  services.udev.extraRules = ''
    # Teensy rules for the Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  '';

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbVariant = "bepo";
  };

  # Optimization for Intel GPU
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Have same layout in TTY than in X (bepo)
  console.useXkbConfig = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    tapping = false;
    clickMethod = "none";
    disableWhileTyping = true;
  };

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.emacs.enable = true;

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users = {
    antonin = {
      isNormalUser = true;
      extraGroups = [
        "docker" # Docker
        "libvirt" # Virtualisation
        "networkmanager" # Network
        "wheel" # Sudo
      ];
    };
  };

  programs.ssh.startAgent = true;
  programs.zsh.shellAliases = {
    ":q" = "echo 'You are not in Vim, you stupid...'";
    RM = "rm -rdvf";
    SRM = "sudo rm -rdvf";
    df = "df -h";
    du = "du -h";
    ezsh = "echo 'Reloading ZSH...' && exec zsh";
    free = "free -h";
    hc = "herbstclient";
    history = "history -i";
    hsrc = "$EDITOR ~/.config/herbstluftwm/autostart";
    i3rc = "$EDITOR ~/.config/i3/config";
    k = "kak";
    krc = "$EDITOR ~/.config/kak/kakrc";
    llr = "ls -lR";
    lr = "ls -R";
    meteo = "curl http://wttr.in/$CITY";
    meteoo = "curl http://v2.wttr.in/$CITY";
    miec = "mix ecto.create";
    miem = "mix ecto.migrate";
    miex = "iex -S mix";
    mips = "mix phx.server";
    mpnv = "mpv --no-video";
    mutt = "neomutt";
    mvv = "mv -v";
    nrb = "sudo nixos-rebuild build";
    nrdb = "sudo nixos-rebuild dry-build";
    nrs = "sudo nixos-rebuild switch";
    nrt = "sudo nixos-rebuild test";
    powertop = "sudo powertop";
    spro = "ssh -D 1080 -q -C -N";
    v = "vim";
    vg = "vagrant";
    vgd = "vagrant destroy";
    vgp = "vagrant provision";
    vgs = "vagrant ssh";
    vgup = "vagrant up";
    vgupp = "vagrant up --provision";
    ztf = "zathura --mode fullscreen";
  };
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    ZSH_THEME="ys"
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"
    HIST_STAMPS="yyyy-mm-dd"

    # Customize your oh-my-zsh options here
    # plugins=(
    #   git
    #   sudo
    #   fancy-ctrl-z
    # )

    source $ZSH/oh-my-zsh.sh
    source ${pkgs.zsh-completions}/share/zsh/site-functions/
    source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh

    export BAT_THEME="OneHalfDark"
    export CITY="bordeaux"
    export EDITOR="emacs"
    export ERL_AFLAGS="-kernel shell_history enabled"
    export GIT_PAGER="delta --theme 'Monokai Extended Bright'"
    #export GPG_TTY=$(tty)
    export MANPAGER=less
    export OPENER=$EDITOR
    export PAGER=bat
    export PATH=$PATH:~/.emacs.d/bin
    export PATH=$PATH:/home/$USER/.cargo/bin
    export PATH=$PATH:/home/$USER/.local/bin/
    export PATH=$PATH:/home/$USER/.mix/escripts/


    alias -g dnull="/dev/null"

    eval $(thefuck --alias)
    if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then ssh-add; fi 

    mkcd ()
    {
        mkdir -p $1 && cd $1
    }

  '';
  programs.zsh.ohMyZsh.plugins =
    [ "colored-man-pages" "git" "sudo" "fancy-ctl-z" ];

  programs.zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

