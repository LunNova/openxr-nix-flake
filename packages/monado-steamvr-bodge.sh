#!/usr/bin/env bash

set -xeuo pipefail

echo >&2 "this script will delete some library files from your steam-runtime that are incompatible with the monado steamvr driver"
echo >&2 "this may break steam games and is a horrible bodge"
echo >&2 "I don't have a better idea. :/"
read -r -p "Press enter to continue or ctrl-c if the above makes you want to :cloudsmash: someone at valve"

sudo setcap CAP_SYS_NICE+ep ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher

steam-run ~/.steam/steam/steamapps/common/SteamVR/bin/vrpathreg.sh adddriver "$MONADO_PATH"/share/steamvr-monado

rm ~/.local/share/Steam/ubuntu12_32/steam-runtime/usr/lib/x86_64-linux-gnu/libelf.so*
rm ~/.local/share/Steam/ubuntu12_32/steam-runtime/usr/lib/x86_64-linux-gnu/liborc*
rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/usr/lib/x86_64-linux-gnu/gst*
rm ~/.local/share/Steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/steam-runtime-heavy/lib/x86_64-linux-gnu/libselinux.so.1
