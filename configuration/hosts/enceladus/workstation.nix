{ config, pkgs, lib, ... }:

{

  services = {
    emacs.enable = true;
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
  };

  users.users.duponin.shell = pkgs.zsh;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.duponin = {
      home.packages = with pkgs; [ ripgrep ];
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        userName = "duponin";
        userEmail = "pwet@dupon.in";
        delta.enable = true;
        extraConfig.pull.ff = "only";
        # signing = true;
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        nix-direnv.enableFlakes = true; # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
      };
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        autocd = true;

        history.extended = true;

        oh-my-zsh.enable = true;
        oh-my-zsh.theme = "ys";

        # promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
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
        envExtra = ''
          COMPLETION_WAITING_DOTS="true"
          ENABLE_CORRECTION="true"
          # HIST_STAMPS="yyyy-mm-dd"
          ERL_AFLAGS="-kernel shell_history enabled"
          EDITOR="emacsclient"
          OPENER=$EDITOR
        '';
        initExtra = ''
          # if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then ssh-add; fi

          mkcd ()
          {
              mkdir -p $1 && cd $1
          }
  
        '';
      };
      programs.tmux.enable = true;
    };
  };
}
