#!/bin/bash

set -e

TARGET=$1
shift # Remove target neme from args so $@ contains (optional) make args

if [ ! -e ${TARGET}.config ]; then
    echo "Failed to build ${TARGET}: Config file ${TARGET}.config not found"
    exit 1
fi

gosu openwrt ./scripts/feeds update -a
gosu openwrt ./scripts/feeds install \
     bluez-libs expat glib2 \
     dbus c3listener libical \
     c3-listener-hw-support c3-raspi-support

FW_OUTPUT_DIR="c3-fw"
VERSION=$(awk -F= '/PKG_VERSION:/ {print $2}' feeds/c3/c3listener/Makefile)
BASE_NAME=c3listener-fw-${TARGET}-${VERSION}
OUT_FILE=""

if [ "${TARGET}" == "raspi3" ]; then
    SRC_FILE="bin/brcm2708/openwrt-brcm2708-bcm2710-rpi-3-ext4-sdcard.img.gz"
    OUT_FILE="${FW_OUTPUT_DIR}/${BASE_NAME}-sdcard.img.gz"
elif [ "${TARGET}" == "whitebox" ]; then
    # Whitebox produces two images for 8M and 16M models
    SRC_FILE="bin/ar71xx/openwrt-ar71xx-generic-gl-inet-6408A-v1-squashfs-sysupgrade.bin"
fi

if [ "${OUT_FILE}x" == "x" ]; then
    OUT_FILE=${FW_OUTPUT_DIR}/${BASE_NAME}-sysupgrade.bin
fi

if [ -e $OUT_FILE ]; then
    echo "Output file: ${OUT_FILE} found. Not rebuilding it."
    exit 2
fi

gosu openwrt cp ${TARGET}.config .config
gosu openwrt make clean
gosu openwrt make olddefconfig
gosu openwrt make $@
if [ "${SRC_FILE}x" == "x" ]; then
    SRC_FILE=$(find ./bin/ar71xx -name "*squashfs-sysupgrade.bin" -print -quit)
fi
cp "${SRC_FILE}" "${OUT_FILE}"
fi
