#!/bin/sh
#
# ndk_build.sh - 使用Android NDK 为不同的移动架构构建rsync二进制文件
#
# daliujs <daliujs@163.com>
#

# Whether or not to strip binaries (smaller filesize)
STRIP=1

API=28
SYSPREFIX="${NDK_ROOT}/platforms/android-${API}/arch-"
ARCH=(armv7 arm64 x86_64)
CCPREFIX=(armv7a-linux-androideabi aarch64-linux-android x86_64-linux-android)
STRIPPREFIX=(arm-linux-androideabi aarch64-linux-android x86_64-linux-android)
ARCH2=(arm aarch64 x86_64)

cd rsync/
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	make clean
	export CC="${NDK_ROOT}/toolchains/llvm/prebuilt/darwin-x86_64/bin/${CCPREFIX[$I]}${API}-clang -v -isysroot=${SYSPREFIX}${ARCH2[$I]}"
	./configure CFLAGS="-static" --host="${ARCH2[$I]}"
	make
	(( $STRIP )) && ${NDK_ROOT}/toolchains/llvm/prebuilt/darwin-x86_64/bin/${STRIPPREFIX[$I]}-strip rsync
	mv rsync "../rsync-${ARCH[$I]}"
done
cd -

echo "\033[1;33m"
for I in $(seq 0 $((${#ARCH[@]} - 1))); do
	file "rsync-${ARCH[$I]}"
done
echo "\033[0m"
