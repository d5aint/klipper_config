#!/bin/sh
#

########################################################################
##
## reboots camera
## use lsusb to get bus and device IDs
##
## source https://gist.github.com/turingbirds/3cb9e64df0c09f5ffda6
## Compile ANSI C code and maybe make executable
## cc usbreset.c -o usbreset
## chmod +x usbreset
## 
########################################################################

MSG=""
ERROR=0

function rebootCamera()
{
    camera=$1

	BUS=$(lsusb | grep "$camera" | cut -d ' ' -f2)
	if [[ -n "$BUS" ]] && [[ "$BUS" =~ ^[0-9]+$ ]]; then
	    DEV=$(lsusb | grep "$camera" | cut -d ':' -f1 | cut -d ' ' -f4)
		NM=$(lsusb | grep "$camera" | cut -d ' ' -f9-12)

        rbcm=$(sudo /home/pi/usbreset /dev/bus/usb/$BUS/$DEV)
		if [[ $rbcm == *"Reset successful"* ]]; then
		    ERROR=0
			MSG="Camera '$camera' found on BUS: ${BUS} and successfully rebooted."
		else
		    ERROR=1
			MSG="Camera found on BUS: ${BUS} but failed to reboot."
		fi
	else
	    ERROR=1
        MSG="Failed to find camera '${camera}'."
	fi
}

if [[ -n "$1" ]]; then
    rebootCamera "$1"

    if [ $ERROR -eq 1 ]; then
        echo "VALUE_UPDATE:status=${MSG}"
        exit 1
    fi

    echo "VALUE_UPDATE:status=${MSG}"
    exit 0
else
	echo "VALUE_UPDATE:status=Missing parameter!"
fi