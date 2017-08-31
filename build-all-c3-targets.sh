#!/bin/bash

set -e

CONFIGS="whitebox raspi3 whitebox-poe chiwawa"
FW_OUTPUT_DIR="c3-fw"

./scripts/feeds update c3

VERSION=$(awk -F= '/PKG_VERSION:/ {print $2}' feeds/c3/c3listener/Makefile)


for config in $CONFIGS; do
    BASE_NAME=c3listener-fw-${config}-${VERSION}
    OUT_FILE=""
    if [ "${config}" == "raspi3" ]; then
	SRC_FILE="bin/brcm2708/openwrt-brcm2708-bcm2710-rpi-3-ext4-sdcard.img.gz"
	OUT_FILE="${FW_OUTPUT_DIR}/${BASE_NAME}-sdcard.img.gz"
    elif [ "${config}" == "whitebox" ]; then
	# Whitebox produces two images for 8M and 16M models
	SRC_FILE="bin/ar71xx/openwrt-ar71xx-generic-gl-inet-6408A-v1-squashfs-sysupgrade.bin"
    fi
    if [ "${OUT_FILE}x" == "x" ]; then
	OUT_FILE=${FW_OUTPUT_DIR}/${BASE_NAME}-sysupgrade.bin
    fi
    if [ -e $OUT_FILE ]; then
	echo "Output file: ${OUT_FILE} found, skipping target"
	continue
    else
	cp ${config}.config .config
	make clean
	make defconfig 0<&-
	make $@
	if [ "${SRC_FILE}x" == "x" ]; then
	    SRC_FILE=$(find ./bin/ar71xx -name "*squashfs-sysupgrade.bin" -print -quit)
	fi
	cp "${SRC_FILE}" "${OUT_FILE}"
    fi
done
