#!/bin/bash -i

#
# Build AppImages from EPICS base.
#
# Tong Zhang, 2021-11-03
#
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  set +u
  rm -rf $appdir_path_var > /dev/null
}

# initialization before building AppImages
init() {
    echo "Initialization..."
    #exe_name="softIocPVA"
    exe_name="caget caput camonitor cainfo softIoc"
    exe_name+=" pvget pvput pvmonitor pvinfo pvcall p2p softIocPVA"
    # combined=false # each exe to one AppImage
    combined=true # all exes to a single AppImage
    base_ver="7.0.6.1"
    cwdir="."
    base_path="${cwdir}/base-${base_ver}"
    appdir_path="AppDir"
    packages_to_install=""
}

# Modified AppDir, if needed.
# $1: executable name, $2: base path $3: path of AppDir
patch-appdir(){
    # app-wise recipe
    local basedir=$2
    local appdir=$3
    case "${1-}" in
        softIoc)
            recipe-softIoc $basedir $appdir
            ;;
        softIocPVA)
            recipe-softIocPVA $basedir $appdir
            ;;
    esac
}

# Additional work needs done for creating AppImage for softIoc
# $1: base path, $2: AppDir path
recipe-softIoc() {
    mkdir -p $2/dbd
    cp $1/dbd/softIoc.dbd $2/dbd
}

# Additional work needs done for creating AppImage for softIocPVA
# $1: base path, $2: AppDir path
recipe-softIocPVA() {
    mkdir -p $2/dbd
    cp $1/dbd/softIocPVA.dbd $2/dbd
}

# build one appimage
build-appimage() {
    ## Real work started below...
    ## Initialization
    init

    ## Install additional pacakge via apt-get
    # install-packages pkg-name1 pkg-name2 ...
    install-packages $packages_to_install

    ## grab the source if does not exist
    get-epics-base $base_ver $cwdir

    ## build epics base
    build-epics-base $base_path

    # create AppImage(s)
    if ! [[ "$combined" = true ]]; then
        appdir_path=""
        for app in $exe_name; do
            create-appdir $base_path $app $appdir_path && \
                appdir_path_var=$(get-appdir $app) && \
                patch-appdir ${app} ${base_path} ${appdir_path_var} && \
                generate-appimage ${appdir_path_var} &
        done
        wait
    else
        echo "Build all ELFs into a single one AppImage."
        appdir_path_var=${appdir_path}
        for app in $exe_name; do
            create-appdir $base_path $app $appdir_path
            patch-appdir ${app} ${base_path} ${appdir_path}
        done
        rm $appdir_path/AppRun && \
            find $appdir_path \( -iname '*.desktop' -o -iname '*.png' \) \
            -exec rm {} \;
        # placeholder ELF as the entrypoint for all
        ! [ -e /tmp/bin/ ] && mkdir /tmp/bin
        cp /bin/ls /tmp/bin/epics-base-tools
        create-appdir "/tmp" "epics-base-tools" $appdir_path \
            entrypoint.desktop \
            EPICS_Logo-192x192.png
        # patch AppRun
        rm $appdir_path/AppRun $appdir_path/usr/bin/epics-base-tools && \
            cp entrypoint.sh $appdir_path/AppRun
        # bundled ELFs
        generate-appimage ${appdir_path}
    fi
}

#
build-appimage
