#!/bin/sh
ARCH=(armv7 arm64 x86_64)
echo "\033[1;33m"
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
        file "rsync-${ARCH[$I]}"
done
echo "\033[0m"

