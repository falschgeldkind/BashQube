#! /bin/bash

export path_script=$(pwd)
source $path_script/utils.sh
#source $path_script/manual_installation.sh
source $path_script/version_management.sh
source $path_script/display.sh

#initialize

handle_cli_args $@

#get scripts
export autoscripts=()
export manualscripts=()
export automenupoints=()
export manumenupoints=()

generate_software_version_catalogue
if [ ! -v $config_file ]; then
	if ! read_conf $config_file; then
		echo "You can see which sofware and which versions of it are supported by this suite by taking a look at:
$(realpath $path_config/reference.conf)"
		exit 1
	else
		source $config_file
	fi
fi


#show the querry whether the installation should proceed automatically
if ! $automated; then
	display_automation_question
fi

#run the scripts in numerical order
## After all scripts beginning with 0 are done, trigger the manual installation, then resume with the remaining automated ones
manual_step_done=false
for script in $autoscripts; do
  if [ $manual_step_done == false ] && [[ $script != 0* ]]; then
    display_manual_step_selection
    manual_step_done=true
  fi
  echo $script
  sleep 3
  echo "Executing $script..."
  call_and_log $path_auto/$script
  if [[ $? != 0 ]]; then
    echo "ERROR! $script finished with exit code $?!"
  fi
  sleep 1
done
