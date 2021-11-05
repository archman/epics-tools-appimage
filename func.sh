#!/usr/bin/env bash
#
# Build AppImages from EPICS base.
#
# Tong Zhang, 2021-11-03
#

# Install additional dependencies, $@
function install-packages {
    echo "Install Debian packages..."
    ! [[ $# -eq 0 ]] && apt-get -y install "$@" || return 0
}

#
# Get EPICS base source code, $1: version string, [$2]: working directory
# artifacts generated show up in the current directory
function get-epics-base {
    local ver=$1
    echo "Get EPICS base version ${ver}..."
    local cwdir=${2:-"$(pwd)"}
    if ! [[ -e "${cwdir}/base-${ver}" ]]; then
        ! [[ -e ${cwdir} ]] && mkdir -p ${cwdir}
        wget --no-check-certificate \
            https://epics.anl.gov/download/base/base-${ver}.tar.gz && \
        tar xvf base-${ver}.tar.gz -C "${cwdir}"
        rm base-${ver}.tar.gz
    else
        echo "EPICS base version ${ver} exists."
    fi
}

# Build EPICS base, $1: path of base, $2: # of make jobs
function build-epics-base {
    echo "Build EPICS base..."
    local basedir=$1
    local n=${2:-"$(cat /proc/cpuinfo | grep processor | wc -l)"}
    (cd ${basedir} && make -j${n})
}

# Create AppDir.
# $1: base path, $2: executable name, $3: appdir path, $4: desktop entry path (optional), $5: icon path (optional)
# return appdir_path
function create-appdir {
    echo "Create AppImage for $1..."
    local exe_path=$(find "$1/bin" -name $2 -exec readlink -f {} \;)
    local appdir_path=${3:-"/tmp/AppDir-$2"}
    local desktop_path=${4:-}
    local icon_path=${5:-"/tmp/tux.png"}
    if [ -z ${desktop_path} ]; then
        linuxdeploy --executable ${exe_path} \
                    --icon-file ${icon_path} \
                    --icon-filename=$2 \
                    --create-desktop-file \
                    --appdir ${appdir_path}
    else
        icon_name=$(basename ${icon_path})
        sed -i /Icon/"s|.*|Icon=${icon_name%%.*}|" ${desktop_path}
        linuxdeploy --executable ${exe_path} \
                    --icon-file ${icon_path} \
                    --desktop-file ${desktop_path} \
                    --appdir ${appdir_path}
    fi
    echo "$appdir_path" > /tmp/.APPDIRPATH-$2
}

# $1: executable name
function get-appdir {
    [ -f /tmp/.APPDIRPATH-$1 ] && cat /tmp/.APPDIRPATH-$1 || echo "None"
}

#
# Create AppImage.
# $1: AppDir path
function generate-appimage {
    local appdir_path=$1
    linuxdeploy --appdir $appdir_path --output appimage
}
