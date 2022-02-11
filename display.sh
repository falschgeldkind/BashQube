#!/bin/bash

display_manual_step_selection() {
  while true; do
    exec 3>&1
    selection=$(dialog \
      --backtitle "$(lsb_release -sd)" \
      --title "Einrichtungsskript" \
      --clear \
      --cancel-label "Automatisierte Einrichtung fortsetzen" \
      --menu "Bitte auswählen:" $HEIGHT $WIDTH 6 \
      $(echo $manumenupoints) \
      2>&1 1>&3)
    exit_status=$?
    exec 3>&-
    case $exit_status in
    $DIALOG_CANCEL)
      #clear
      echo "Program terminated."
      break
      ;;
    $DIALOG_ESC)
      #clear
      break
      ;;
    esac
    #compose menu entries
    for s in $manualscripts; do
      if [[ 1$s == $selection* ]]; then
        call_and_log $path_manu/$s
      fi
    done
    sleep 5
  done
}

display_all_step_selection() {
  while true; do
    exec 3>&1
    selection=$(dialog \
      --backtitle "$(lsb_release -sd)" \
      --title "Einrichtungsskript" \
      --clear \
      --cancel-label "Exit" \
      --menu "Bitte auswählen:" $HEIGHT $WIDTH 6 \
      $(echo $automenupoints && echo $manumenupoints) \
      2>&1 1>&3)
    exit_status=$?
    exec 3>&-
    case $exit_status in
    $DIALOG_CANCEL)
      #clear
      echo "Program terminated."
      break
      ;;
    $DIALOG_ESC)
      #clear
      echo "Program aborted." >&2
      break
      ;;
    esac
    #compose menu entries
    for autoscript in $autoscripts; do
      if [[ $autoscript == $selection* ]]; then
        call_and_log $path_auto/$autoscript
      fi
    done

    for manuscript in $manualscripts; do
      if [[ 1$manuscript == $selection* ]]; then

        call_and_log $path_manu/$manuscript
      fi
    done
    sleep 5
  done
}

display_automation_question() {
  exec 3>&1
	selection=$(dialog \
	  --backtitle "$(lsb_release -sd)" \
	  --clear \
	  --title "Einrichtungsskript" \
	  --yesno "Möchten Sie die Grundeinrichtung automatisiert durchführen?
	    Bitte auswählen:" $HEIGHT $WIDTH \
	  2>&1 1>&3)
	exit_status=$?
	exec 3>&-
	case $exit_status in
	$DIALOG_CANCEL)
	  #clear
	  #run the scripts manually
	  display_all_step_selection
	  exit
	  ;;
	0)
	  #clear
    get_selections
    source $path_config/config.conf
    ;;
  $DIALOG_ESC)
    #clear
    echo "Program aborted." >&2
    exit 1
    ;;
	esac
}

display_software_version_selection() {
  name=$1
  versions=$(
    for i in ${@:2}; do
      echo $i
      echo $i
      echo off
    done
  )
  dialog --checklist "Wählen sie die gewünschten Versionen von $name" 0 0 0\
  $versions 3>&1 1>&2 2>&3
}

print_help() {
  echo "BashQube script suite"
  echo
  echo "Syntax: Main.sh [-c|g|h]"
  echo "Options:"
  echo "-c config_file"
  echo "      Start automatic configuration based on the given config file"
  echo "-g target_file"
  echo "      Generate a config by multiple choice selections and write it to the given file"
  echo "-h    Print this help"
}
