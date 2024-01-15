#!/bin/bash
# requires: wget curl
set -e
set -o pipefail

_here=`dirname $(realpath $0)`
apt_sync="${_here}/apt-sync.py"

BASE_PATH="${TUNASYNC_WORKING_DIR}"
BASE_URL=${TUNASYNC_UPSTREAM_URL:-"https://packages.openmediavault.org/public"}
DISTS=sandworm,sandworm-proposed,shaitan-proposed,shaitan,usul-proposed,usul
EXTRA_DISTS=sandworm,shaitan-beta,shaitan-testing,shaitan,usul-beta,usul-extras,usul-testing,usul
ARCHS=amd64,i386,arm64,armel,armhf
export REPO_SIZE_FILE=/tmp/reposize.$RANDOM

# =================== official repos ===============================
"$apt_sync" --delete "${BASE_URL}" "$DISTS" main,partner $ARCHS "${BASE_PATH}/public"
"$apt_sync" --delete "https://openmediavault.github.io/packages" "$DISTS" main,partner $ARCHS "${BASE_PATH}/packages"
# =================== extra repos ===============================
wget -O "${BASE_PATH}/openmediavault-plugin-developers/omvextras2026.asc" https://openmediavault-plugin-developers.github.io/packages/debian/omvextras2026.asc
"$apt_sync" --delete "https://openmediavault-plugin-developers.github.io/packages/debian" \
    "$EXTRA_DISTS" main $ARCHS "${BASE_PATH}/openmediavault-plugin-developers"
echo "APT finished"

"${_here}/helpers/size-sum.sh" $REPO_SIZE_FILE --rm
