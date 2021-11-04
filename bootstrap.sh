#!/usr/bin/env bash
#
# Build AppImages from EPICS base.
#
# Tong Zhang, 2021-11-03
#
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
TMPDIRS=()

function cleanup {
  trap - SIGINT SIGTERM ERR EXIT
  for d in "${TMPDIRS[@]}"
  do
    rm -rf $d
  done
}

# Other initialization before building AppImages
function init {
    echo "Initialization..."
}

# Install additional dependencies, $@
function install-packages {
    echo "Install Debian packages..."
    ! [[ $# -eq 0 ]] && apt-get -y install "$@" || return 0
}

#
# Get EPICS base source code
# artifacts generated show up in the current directory
function get-epics-base {
    echo "Get EPICS base version ${ver}..."
    ! [[ -e base-${ver} ]] && wget --no-check-certificate \
        https://epics.anl.gov/download/base/base-${ver}.tar.gz && \
        tar xvf base-${ver}.tar.gz || return 0
}

# Build EPICS base
function build-epics-base {
    echo "Build EPICS base..."
    cd base-${ver}
    make -j4
    cd ../
}

# Create AppImage,
# $1: executable name, $2: desktop entry path (optional), $3: icon path (optional)
function create-appimage {
    echo "Create AppImage for $1..."
    exe_path=$(find base-${ver}/bin -name $1 -exec readlink -f {} \;)
    app_dir_name="AppDir-$1"
    desktop_path=${2:-}
    icon_path=${3:-"/tmp/tux.png"}
    if [ -z ${desktop_path} ]; then
        linuxdeploy --executable ${exe_path} \
                    --icon-file ${icon_path} \
                    --icon-filename=$1 \
                    --create-desktop-file \
                    --appdir ${app_dir_name}
    else
        icon_name=$(basename ${icon_path})
        sed -i /Icon/"s|.*|Icon=${icon_name%%.*}|" ${desktop_path}
        linuxdeploy --executable ${exe_path} \
                    --icon-file ${icon_path} \
                    --desktop-file ${desktop_path} \
                    --appdir ${app_dir_name}
    fi
    # app-wise recipe
    case "${1-}" in
        softIoc)
            recipe-softIoc ${app_dir_name}
            ;;
        softIocPVA)
            recipe-softIocPVA ${app_dir_name}
            ;;
    esac
    linuxdeploy --appdir ${app_dir_name} --output appimage
}

# Additional work needs done for creating AppImage for softIoc
function recipe-softIoc {
    local app_dir_name=$1
    mkdir -p ${app_dir_name}/dbd
    cp base-${ver}/dbd/softIoc.dbd ${app_dir_name}/dbd
}

# additional work needs done for creating AppImage for softIocPVA
function recipe-softIocPVA {
    local app_dir_name=$1
    mkdir -p ${app_dir_name}/dbd
    cp base-${ver}/dbd/softIocPVA.dbd ${app_dir_name}/dbd
}

## Real work started below...
## Initialization
init

## Install additional pacakge via apt-get
# install-packages pkg-name1 pkg-name2 ...
install-packages

## grab the source if does not exist
ver="7.0.6.1"
get-epics-base

## build epics base
build-epics-base

## create one AppImage at a time
# create-appimage softIoc desktop-entries/softIoc.desktop desktop-entries/tux1.png
# create-appimage caget

#all_elfs=$(find base-${ver}/bin/ -type f -exec file {} \; | grep ELF \
#           | awk -F':' '{print $1}' | awk -F'/' '{print $NF}' | xargs)
#exe_list=${all_elfs}

## create multiple AppImages at the same time
exe_list="caget caput camonitor cainfo softIoc"
exe_list+=" pvget pvput pvmonitor pvinfo pvcall p2p softIocPVA"
for app_name in ${exe_list}; do
    TMPDIRS+=("AppDir-$app_name")
    create-appimage ${app_name} &
done
wait
