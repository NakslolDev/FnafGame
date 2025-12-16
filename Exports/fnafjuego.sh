#!/bin/sh
printf '\033c\033]0;%s\a' Fnaf [Nombre Provisional]
base_path="$(dirname "$(realpath "$0")")"
"$base_path/fnafjuego.x86_64" "$@"
