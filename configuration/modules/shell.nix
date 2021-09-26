{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.shell;
in {
  options.duponin.shell.enable = mkEnableOption "The hacker known as 4chan";

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
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
}
