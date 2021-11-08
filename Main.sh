#! /bin/bash

export path_script=$(pwd)
source $path_script/utils.sh

check_if_root

source $path_script/manual_installation.sh

apt update
apt upgrade -y


#Install dialog
apt install -y dialog zenity xclip

#get scripts
export autoscripts=( )
export manualscripts=( )
export automenupoints=( )
export manumenupoints=( )

for f in $path_auto/*.sh
do
	autoscripts+="$(echo $f | rev | cut -d / -f 1 | rev | grep -oP '^\d{2}.*.sh') "
done
for s in $autoscripts
do
    number="$(echo $s | grep -oP '(\d{2})(?=(_))') "
    name="$(echo $s | grep -o -P '(?<=(\d\d_)).*(?=.sh)') "
    automenupoints+=$number
    automenupoints+=$name
done

for f in $path_manu/*.sh
do
	manualscripts+="$(echo $f | rev | cut -d / -f 1 | rev | grep -oP '^\d{2}.*.sh') "
done
for s in $manualscripts
do
    number="1$(echo $s | grep -oP '(\d{2})(?=(_))') "
    name="$(echo $s | grep -o -P '(?<=(\d\d_)).*(?=.sh)') "
    manumenupoints+=$number
    manumenupoints+=$name
done

#show the querry whether the installation should proceed automatically
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
        manual_configuration
    exit;;
    $DIALOG_ESC)
        #clear
        echo "Program aborted." >&2
    exit 1;;
esac

#run the scripts in numerical order
## After all scripts beginning with 0 are done, trigger the manual installation, then resume with the remaining automated ones
manual_step_done=false
for script in $autoscripts
do
	if [ $manual_step_done == false ] && [[ $script != 0* ]]
	then
		manual
		manual_step_done=true
	fi
	echo $script
	sleep 3
	echo "Executing $script..."
    call_and_log $path_auto/$script
    if [[ $? != 0 ]]
    then
        echo "ERROR! $script finished with exit code $?!"
    fi
    sleep 1
done
