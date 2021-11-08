BashQube allows you to configure a Ubuntu (probably debian too) machine after initial installation via configuration scripts. It installs all it's required scripts itself. It is meant to speed up initial configuration as much as possible with as much flexibility as possible, just using bash scripts.

BashQube offers automatic (back-to-back) or manual execution and logging for fully-automated configuration steps via scripts. It also offers a selection window for manual tasks after all basic configuration tasks are done. After that it continues with the automatic configuration.

BashQube automatically executes fully-automated tasks (scripts) back to back in a specific order defined by numbered filenames (e.g. \d\d_script.sh).
BashQube also allows you to do non-fully automated configurations after basic configuration (e.g. software sources on NFS).

FULLY AUTOMATED CONFIGURATIONS
Put scripts that are fully automated and do not require any interaction in the 'automated' directory. Tasks beginning with '0' are considered basic configuration. Which means they are executed before BashQube asks for manual configuration steps

MANUAL CONFIGURATION
Put scripts that require active oversight or manual interaction (e.g. non silent, interactive installations) in the 'manual' directory

BashQube provides and uses some path variables. 
can use in your scripts. They are set in utils.sh


=== Start BashQube ===
IMPORTANT!
The current working directory MUST be the one the script is in!
Make sure you are in the correct directory!

sudo bash ./Main.sh


path_auto=$path_script/automated
#export path_auto=$path_script/dev/automated
export path_manu=$path_script/manual
#export path_manu=$path_script/dev/manual
export path_config=$path_script/config
export path_rsc=$path_script/rsc
export path_software=/media/spock/SOFT
