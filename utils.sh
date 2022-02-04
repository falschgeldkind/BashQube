#!/bin/bash

### Dev switch - set true for development and testing purposes (dev directory is used if true)
dev=false

if $dev; then
  export path_auto=$path_script/dev/automated
  export path_manu=$path_script/dev/manual
  export path_config=$path_script/dev/config
  export path_rsc=$path_script/dev/rsc
else
  ### Path to scripts (yes, you can change these directories!)
  export path_auto=$path_script/automated
  export path_manu=$path_script/manual
  export path_config=$path_script/config
  export path_rsc=$path_script/rsc
fi

### Path to logfile
export logfile=$path_script/setup$(date --iso-8601=seconds)date.log

### Path to Software sources
export path_software=/your/software/directory/
#export path_software2=/maybe/another/software/directory/?/

### UI Constants
export DIALOG_CANCEL=1
export DIALOG_ESC=255
export HEIGHT=0
export WIDTH=0

###do not change if you dont know what it does!
export automated=false

initialize() {
  check_if_root

  apt update
  apt upgrade -y

  #Install dialog
  apt install -y dialog zenity xclip
}

check_if_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
  fi
}

### function for displaying the UI
display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

### function for calling and logging a script cast via commandline parameter
call_and_log() {
  exec 3>&1 4>&2 &> >(tee -a "$logfile") 2>&1
  echo "========== $1 =========" >>$logfile
  $1
  if [[ $? != 0 ]]; then
    exit 1
  fi
  exec 1>&3 2>&4
  echo >&2 "Done"
}

get_versions() {
  grep -Po '#*Versions: \K.*' "$1"
}
