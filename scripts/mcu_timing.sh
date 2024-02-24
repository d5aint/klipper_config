#!/bin/bash

MSG=""
ERROR=0

increase_mcu_timing()
{
    sed -i 's/^TRSYNC_TIMEOUT = 0.025$/TRSYNC_TIMEOUT = 0.05/' $HOME/klipper/klippy/mcu.py
	
    if grep -q "TRSYNC_TIMEOUT = 0.05" $HOME/klipper/klippy/mcu.py; then
        ERROR=0
        MSG="MCU timing modified successfully."
    else
        ERROR=1
        MSG="Failed to modify MCU timing!"
    fi
}

function restore_mcu_timing()
{
    rm $HOME/klipper/klippy/mcu.py
    curl -o $HOME/klipper/klippy/mcu.py https://raw.githubusercontent.com/Klipper3d/klipper/master/klippy/mcu.py
    cd $HOME/klipper && git pull
    
    if grep -q "TRSYNC_TIMEOUT = 0.025" $HOME/klipper/klippy/mcu.py; then
        ERROR=0
        MSG="MCU timing has been restored to defaults."
    else
        ERROR=1
        MSG="Failed to restore MCU timing to defaults!"
    fi
}

if [ "$1" == "install" ]; then
    increase_mcu_timing
    
    if [ $ERROR -eq 1 ]; then
        echo "VALUE_UPDATE:status=${MSG}"
        exit 1
    fi

    echo "VALUE_UPDATE:status=${MSG}"
    exit 0
fi

if [ "$1" == "update" ]; then
    restore_mcu_timing
    
    if [ $ERROR -eq 1 ]; then
        echo "VALUE_UPDATE:status=${MSG}"
        exit 1
    else
        sleep 1
        increase_mcu_timing
        if [ $ERROR -eq 1 ]; then
            echo "VALUE_UPDATE:status=${MSG}"
            exit 1
        fi
    fi
    
    MSG="Klipper updated successfully and MCU timing remodified successfully."
    echo "VALUE_UPDATE:status=${MSG}"
    exit 0
fi

if [ "$1" == "remove" ]; then
    restore_mcu_timing

    if [ $ERROR -eq 1 ]; then
        echo "VALUE_UPDATE:status=${MSG}"
        exit 1
    fi
    
    echo "VALUE_UPDATE:status=${MSG}"
    exit 0
fi
    
if [ "$1" == "check" ]; then
    if grep -q "TRSYNC_TIMEOUT = 0.05" $HOME/klipper/klippy/mcu.py; then
        MSG="MCU timing has been modified."
    else
        MSG="MCU timing is set to defaults."
    fi
    
    echo "VALUE_UPDATE:status=${MSG}"
	exit 0
fi