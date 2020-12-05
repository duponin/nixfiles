#!/usr/bin/env bash

nixos-rebuild "$@" -I nixos-config="configuration/hosts/$(hostname)/configuration.nix"
