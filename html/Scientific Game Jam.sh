#!/bin/sh
echo -ne '\033c\033]0;Scientific Game Jam\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Scientific Game Jam.x86_64" "$@"
