#!/usr/bin/bash
# Wrapper script to get/set GSettings from the host in the sandboxed Pantheon Tweaks.
# Originally from https://github.com/flathub/ca.desrt.dconf-editor/blob/master/start-dconf-editor.sh

# Cleanup temporary symlinks and directories this script created.
finalize()
{
  for dir in ${HOST_XDG_DATA_DIRS//:/ }; do
    unlink "$dir/glib-2.0/schemas"
    rmdir "$dir/glib-2.0"
    rmdir "$dir"
  done

  rmdir "$bridge_dir"
}

# $XDG_DATA_DIRS is meant to be expanded in the sh launched by flatpak-spawn instead of this script
# shellcheck disable=SC2016
IFS=: read -ra host_data_dirs < <(flatpak-spawn --host sh -c 'echo "$XDG_DATA_DIRS"')

# To avoid potentially muddying up $XDG_DATA_DIRS too much, we link the schema paths
# into a temporary directory.
bridge_dir="$XDG_RUNTIME_DIR/dconf-bridge"
mkdir -p "$bridge_dir"

HOST_XDG_DATA_DIRS=""

trap "finalize; exit 1" SIGINT

for dir in "${host_data_dirs[@]}"; do
  if [[ "$dir" == /usr/* ]]; then
    dir="/run/host/$dir"
  fi

  schemas="$dir/glib-2.0/schemas"
  if [ -d "$schemas" ]; then
    bridged=$(mktemp -d XXXXXXXXXX -p "$bridge_dir")
    mkdir -p "$bridged/glib-2.0"
    ln -s "$schemas" "$bridged/glib-2.0"
    HOST_XDG_DATA_DIRS="${HOST_XDG_DATA_DIRS}:${bridged}"
  fi
done

# We MUST prepend the host's data dirs BEFORE the Flatpak environment's own dirs,
# otherwise data (such as default values) load in the wrong order and would then
# incorrectly prefer the Flatpak's internal defaults instead of the host's defaults!
if [ -n "${HOST_XDG_DATA_DIRS}" ]; then
  XDG_DATA_DIRS="${HOST_XDG_DATA_DIRS:1}:${XDG_DATA_DIRS}"
fi

export XDG_DATA_DIRS

pantheon-tweaks "$@"
RET=$?

finalize
exit $RET
