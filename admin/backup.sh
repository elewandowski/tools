#!/usr/bin/env bash -e

# newline print
nl_print() {
	printf "\n$1\n"
}

nl_print "WARNING: both source and target drives must be directly connected to the computer, to ensure a stable connection whilst transferring data. e.g. not via USB hub."
nl_print "Are both storage drives connected directly to the computer? [y/n]"

read -n 1 dacd # dacd = drives are connected directly

if [[ ! ( "$dacd" == "y" || "$dacd" == "Y" ) ]]
then
	nl_print "Please connect both drives directly to the computer and restart this script."
	exit 1
fi


SOURCE_DISK="/Volumes/1TB Emil SSD"
TARGET_DISK="/Volumes/2TB Emil Backup"

check_disk_is_connected () {
	DISK_NAME=$1

	if [[ ! -d "$DISK_NAME" ]] 
	then
		nl_print "$DISK_NAME disk was not found. Aborting"
		exit 1
	fi
}

check_disk_is_connected "$SOURCE_DISK"
check_disk_is_connected "$TARGET_DISK"

sudo rsync -avE --ignore-existing --exclude=".*" --delete --progress "$SOURCE_DISK/" "$TARGET_DISK/"