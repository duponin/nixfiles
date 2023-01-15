#! /usr/bin/env bash
# shellcheck disable=SC2029
# shellcheck disable=SC2039

verb=$1

for host in $(ls configuration/hosts) ; do
    echo "######################################################"
    echo $host
    ping -c 1 -W 2 "${host}.locahlost.net" > /dev/null && if [ "$host" = "$(hostname)" ]; then
        echo "# Skipping ${host}, reason: localhost"
    else
        nixos-rebuild $verb --use-remote-sudo --flake ".#${host}" --target-host "${host}.locahlost.net"
    fi
    echo "#-----------------------------------------------------"
done
