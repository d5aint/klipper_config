#!/bin/bash

KLIPPER_DIR="$HOME/klipper"
MCU_FILE="$KLIPPER_DIR/klippy/mcu.py"
MSG=""
ERROR=0

# Check if file exists before doing anything
if [ ! -f "$MCU_FILE" ]; then
    echo "VALUE_UPDATE:status=Error: mcu.py not found at $MCU_FILE"
    exit 1
fi

increase_mcu_timing()
{
    # Check if already modified to avoid double patching
    if grep -q "TRSYNC_TIMEOUT = 0.05" "$MCU_FILE"; then
        MSG="Timing already modified."
        return
    fi

    # Use flexible regex to find the variable, preserving spacing if possible
    # This looks for TRSYNC_TIMEOUT = 0.025 (ignoring leading/trailing spaces)
    sed -i 's/^\s*TRSYNC_TIMEOUT\s*=\s*0.025/TRSYNC_TIMEOUT = 0.05/' "$MCU_FILE"
    
    if grep -q "TRSYNC_TIMEOUT = 0.05" "$MCU_FILE"; then
        ERROR=0
        MSG="MCU timing modified successfully."
    else
        ERROR=1
        MSG="Failed to modify MCU timing!"
    fi
}

restore_mcu_timing()
{
    # Use GIT to checkout the clean version of the file that matches 
    # the currently installed Klipper commit.
    cd "$KLIPPER_DIR" || { echo "VALUE_UPDATE:status=Klipper dir not found"; exit 1; }
    git checkout klippy/mcu.py
    
    # Check if the stock value (0.025) is present
    if grep -q "TRSYNC_TIMEOUT = 0.025" "$MCU_FILE"; then
        ERROR=0
        MSG="MCU timing has been restored to defaults."
    else
        # If git checkout failed or upstream changed the default value
        ERROR=1
        MSG="Failed to restore MCU timing to defaults!"
    fi
}

perform_update()
{
    # 1. Restore file to clean state
    cd "$KLIPPER_DIR" || exit 1
    git checkout klippy/mcu.py
    
    # 2. Pull latest klipper
    MSG="Updating Klipper..."
    if git pull; then
        # 3. Re-apply the patch
        increase_mcu_timing
        if [ $ERROR -eq 0 ]; then
             MSG="Klipper updated and timing remodified successfully."
        fi
    else
        ERROR=1
        MSG="Failed to pull Klipper updates from git."
    fi
}

# --- Main Logic ---

case "$1" in
    "install")
        increase_mcu_timing
        ;;
        
    "update")
        perform_update
        ;;
        
    "remove")
        restore_mcu_timing
        ;;
        
    "check")
        if grep -q "TRSYNC_TIMEOUT = 0.05" "$MCU_FILE"; then
            MSG="MCU timing is MODIFIED (0.05)."
        elif grep -q "TRSYNC_TIMEOUT = 0.025" "$MCU_FILE"; then
            MSG="MCU timing is DEFAULT (0.025)."
        else
            MSG="MCU timing is Unknown/Custom."
        fi
        ;;
        
    *)
        echo "Usage: $0 {install|update|remove|check}"
        exit 1
        ;;
esac

# Final Status Output
if [ $ERROR -eq 1 ]; then
    echo "VALUE_UPDATE:status=${MSG}"
    exit 1
else
    echo "VALUE_UPDATE:status=${MSG}"
    exit 0
fi
