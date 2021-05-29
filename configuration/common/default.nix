{ config, pkgs, lib, ... }:
let
  czkawka = pkgs.callPackage ./czkawka.nix { };
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "2aa20ae969f2597c4df10a094440a66e9d7f8c86";
    ref = "release-20.09";
  };
  unstableTarball = fetchTarball
    "https://codeload.github.com/nixos/nixpkgs/tar.gz/nixos-unstable";
in {
  imports = [ (import "${home-manager}/nixos") ];

  # Mount /tmp on tmpfs at boot
  boot.tmpOnTmpfs = true;

  # Have same layout in TTY than in X (bepo)
  console.useXkbConfig = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # English but date is YYYY/MM/DD
  i18n.defaultLocale = "en_DK.UTF-8";

  networking = {
    firewall = {
      allowedTCPPorts = [
        24800 # Barrier (Software KVM)
        8000 # Webserver to easily share files
      ];
      # allowedUDPPorts = [ ... ];
    };
    networkmanager = {
      enable = true;
      dns = "default";
    };
    useDHCP = false;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  programs = {
    adb.enable = true;
    gnupg = {
      package = pkgs.unstable.gnupg;
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "qt";
      };
    };
    ssh.startAgent = false;
    zsh = {
      enable = true;
      promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
      shellAliases = {
        ":q" = "echo 'You are not in Vim, you stupid...'";
        RM = "rm -rdvf";
        SRM = "sudo rm -rdvf";
        df = "df -h";
        du = "du -h";
        ezsh = "echo 'Reloading ZSH...' && exec zsh";
        free = "free -h";
        history = "history -i";
        meteo = "curl http://wttr.in/$CITY";
        meteoo = "curl http://v2.wttr.in/$CITY";
        miex = "iex -S mix";
        mips = "mix phx.server";
        mpnv = "mpv --no-video";
        nrb = "sudo nixos-rebuild build";
        nrdb = "sudo nixos-rebuild dry-build";
        nrs = "sudo nixos-rebuild switch";
        nrt = "sudo nixos-rebuild test";
        nsl = "nix-shell";
        powertop = "sudo powertop";
        spro = "ssh -D 1080 -q -C -N";
      };
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        COMPLETION_WAITING_DOTS="true"
        ENABLE_CORRECTION="true"
        HIST_STAMPS="yyyy-mm-dd"
        ZSH_THEME='ys'

        # Customize your oh-my-zsh options here
        plugins=(
          git
          sudo
          fancy-ctrl-z
        )

        source $ZSH/oh-my-zsh.sh
        source ${pkgs.zsh-completions}/share/zsh/site-functions/
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh

        export BAT_THEME="OneHalfDark"
        export CITY="bordeaux"
        export EDITOR="emacsclient"
        export ERL_AFLAGS="-kernel shell_history enabled"
        export GIT_PAGER="delta --theme 'Monokai Extended Bright'"
        export GPG_TTY=$(tty)
        export MANPAGER=less
        export OPENER=$EDITOR
        export PAGER=bat
        export PATH=$PATH:~/.emacs.d/bin
        export PATH=$PATH:/home/$USER/.cargo/bin
        export PATH=$PATH:/home/$USER/.local/bin/
        export PATH=$PATH:/home/$USER/.mix/escripts/
        export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"

        eval $(thefuck --alias)
        # if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then ssh-add; fi
        gpg-connect-agent /bye

        mkcd ()
        {
            mkdir -p $1 && cd $1
        }

      '';
    };
  };

  security.hideProcessInformation = true;

  services = {
    emacs.enable = true;
    lorri.enable = true;
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
      enable = true;
      layout = "fr";
      xkbVariant = "bepo";
      displayManager.sddm.enable = true; # Plasma Display Manager
      desktopManager.plasma5.enable = true; # KDE Plasma
      libinput = { # Click with touchpad is HERESY
        enable = true;
        tapping = false;
        clickMethod = "none";
        disableWhileTyping = true;
      };
    };
  };

  sound.enable = true;

  time.timeZone = "Europe/Paris";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
  };
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [
      "adbusers" # ADB
      "docker" # Docker
      "libvirtd" # Virtualisation
      "networkmanager" # Network
      "wheel" # Sudo
    ];
    hashedPassword =
      "$6$rounds=1000000$3P.QolTKfoKz$UOXByJQfwNJJ5M7ChL.A4hlnuNiBX01/j/dHBLOy6vuN6OxJJ/fSF2x0vgpD1ZnvsKTse6V6N.z3b9.4h9WOQ0";
  };
  home-manager.users.duponin = {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Antonin Dupont";
      userEmail = "duponin@locahlo.st";
      delta.enable = true;
      extraConfig = { pull = { ff = "only"; }; };
      # signing = true;
    };
  };

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
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Various tools
    bat
    curl
    direnv
    dnsutils
    unstable.elixir
    fd
    gitAndTools.delta
    gitAndTools.git-bug
    glow
    htop
    jq
    mkpasswd
    mtr
    multimarkdown
    mupdf
    ncdu
    nixfmt
    elmPackages.elm-format
    nmap
    pandoc
    # pinentry-qt
    python3
    ripgrep
    ripgrep-all
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

    # Shell related pkgs
    nix-zsh-completions
    zsh-completions
    zsh-syntax-highlighting
    zsh-you-should-use

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
    audacity
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
    oneko
    openvpn
    plasma-integration
    scrcpy
    simplescreenrecorder
    tdesktop # Telegram
    thunderbird
    transmission-remote-gtk
    virt-manager
    unstable.vivaldi
  ];
}
