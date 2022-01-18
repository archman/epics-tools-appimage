#!/bin/bash

# Run EPICS base tools, with options to:
#   print out info of deployed EPICS tools
#     1. EPICS base version
#     2. Bundled ELFs
#     3. Brief help message on how to call these ELFs
#
# Tong Zhang <zhangt@frib.msu.edu>
# 2021-11-08 11:06:21 EST
#
if [ -z ${ARGV0} ]; then
    SHNAME=$(basename $0)
else
    SHNAME=$(basename ${ARGV0})
fi

usage() {
  cat <<EOF
Usage: epics-base-tools -i -l -h app-name

Run the deployed EPICS base tools.

Available options:

 -i, --info      EPICS base version
 -l, --list      All available EPICS base tools
 app-name        Name of one of the deployed tools
 -h, --help      Print this help and exit
 -v, --verbose   Print script debug info

Examples:
 # use caget tool
 epics-base-tools caget
EOF
  exit
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

print_info() {
    ver_info=$($HERE/usr/bin/caget -V | tail -1)
    msg "Build info:"
    msg ${BLUE}
    echo ${ver_info}
    msg ${NOFORMAT}
    exit
}

list_apps() {
    elfs=$(cd $HERE/usr/bin && find . ! \( -name "${SHNAME}" -o -iname "." \) -exec basename {} \; | sort)
    msg "($(echo ${elfs} | wc -w)) apps are available:"
    msg ${BLUE}
    echo ${elfs}
    msg ${NOFORMAT}
    exit
}

parse_params() {
  app_name=""
  while :; do
    case "${1-}" in
    -i | --info)
        print_info
        ;;
    -l | --list)
        list_apps
        ;;
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")
  [[ ${#args[@]} -eq 0 ]] && msg "${RED}Missing the app name!${NOFORMAT}" && usage

  return 0
}

run_app() {
  EXE_NAME=${1}
  shift
  [ -e "$HERE/usr/bin/${EXE_NAME}" ] && \
      exec "$HERE/usr/bin/$EXE_NAME" "$@" || die "Invalid app name!"
}

HERE="$(dirname "$(readlink -f "${0}")")"
setup_colors
parse_params "$@"
run_app "$@"
