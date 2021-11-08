 #!/in/bash

manual_configuration() {
    while true; do
	    exec 3>&1
	    selection=$(dialog \
		--backtitle "$(lsb_release -sd)" \
		--title "Einrichtungsskript" \
		--clear \
		--cancel-label "Exit" \
		--menu "Bitte auswählen:" $HEIGHT $WIDTH 6 \
		$(echo $automenupoints && echo $manumenupoints)\
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
	    for autoscript in $autoscripts
	    do
			if [[ $autoscript == $selection* ]]
			then
				call_and_log $path_auto/$autoscript
			fi
	    done

	    for manuscript in $manualscripts
	    do
			if [[ 1$manuscript == $selection* ]]
			then

			  call_and_log $path_manu/$manuscript
			fi
	    done
	    sleep 5
    done
}

manual() {
    while true; do
		exec 3>&1
		selection=$(dialog \
		    --backtitle "$(lsb_release -sd)" \
		    --title "Einrichtungsskript" \
		    --clear \
		    --cancel-label "Exit" \
		    --menu "Bitte auswählen:" $HEIGHT $WIDTH 6 \
		    $(echo $manumenupoints)\
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
		for s in $manualscripts
		do
		    if [[ 1$s == $selection* ]]
		    then
		    	call_and_log $path_manu/$s
		    fi
		done
		sleep 5
    done
}
