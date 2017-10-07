#!/bin/bash

set -e

CONFIGS=$(find . \
	       -maxdepth 1 \
	       -type f \
	       -name "*.config" \
	       -a ! -name .config \
	      | xargs basename -s .config)
FW_OUTPUT_DIR="c3-fw"

./scripts/feeds update c3

VERSION=$(awk -F= '/PKG_VERSION:/ {print $2}' feeds/c3/c3listener/Makefile)


for config in $CONFIGS; do
    $PWD/build-c3-target.sh $config $@
done
