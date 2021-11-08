#!/bin/bash

# The purpose of this custom AppRun script is
# to allow symlinking the AppImage and invoking
# the corresponding binary depending on which
# symlink was used to invoke the AppImage

HERE="$(dirname "$(readlink -f "${0}")")"
echo "current working directory: " $HERE
echo "ARGV0: " $ARGV0
echo "basename of ARGV0: " $(basename "$ARGV0")
BINARY_NAME=${1:-"caget"}
shift
echo "Executable: $BINARY_NAME"
echo "arguments: $@"

#if [ ! -z $APPIMAGE ] ; then
#  BINARY_NAME=$(basename "$ARGV0")
if [ -e "$HERE/usr/bin/$BINARY_NAME" ] ; then
    exec "$HERE/usr/bin/$BINARY_NAME" "$@"
else
    exec "$HERE/usr/bin/caget" "$@"
fi
#else
#  exec "$HERE/usr/bin/caget" "$@"
#fi
