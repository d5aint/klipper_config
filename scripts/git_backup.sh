#!/bin/bash
# Backs up the Klipper config folder by committing and pushing it to its
# configured git remote. Meant to be run via Klipper's gcode_shell_command
# extra - the VALUE_UPDATE:status=... lines are consumed by that extra's
# value_status option and surfaced back through the printer's status.
#
# Usage (from a gcode macro, via RUN_SHELL_COMMAND's PARAMS):
#   Any arguments passed to this script become extra `-m` commit message
#   lines, e.g.:
#     RUN_SHELL_COMMAND CMD=backup_config PARAMS="before tuning run"
#
# Override the config path without editing this file via:
#   BACKUP_CONFIG_FOLDER=/path/to/config ./backup_config.sh

set -uo pipefail

CONFIG_FOLDER="${BACKUP_CONFIG_FOLDER:-/home/pi/printer_data/config}"

report_status() {
    echo "VALUE_UPDATE:status=$1"
}

push_config() {
    cd "${CONFIG_FOLDER}" || {
        report_status "Backup failed: could not cd to ${CONFIG_FOLDER}"
        return 1
    }

    if ! git pull -v; then
        report_status "Backup failed: git pull could not update from the remote (check for conflicts)"
        return 1
    fi

    git add -A

    if git diff --cached --quiet; then
        report_status "No config changes to back up"
        return 0
    fi

    local commit_date
    commit_date="$(date +"%Y-%m-%d %T")"
    local -a message_args=(-m "Backup triggered on ${commit_date}")
    local extra
    for extra in "$@"; do
        [ -n "${extra}" ] && message_args+=(-m "${extra}")
    done

    if ! git commit "${message_args[@]}"; then
        report_status "Backup failed: git commit failed"
        return 1
    fi

    if ! git push -v; then
        report_status "Backup failed: git push could not reach the remote"
        return 1
    fi

    report_status "Backup pushed to github successfully"
    return 0
}

push_config "$@"
exit $?
