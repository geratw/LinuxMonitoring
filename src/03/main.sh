#!/bin/bash
chmod +x check_input.sh
chmod +x clean_files.sh

. ./check_input.sh
. ./clean_files.sh

cleanup_option="$1"
parameters=($@)
validate_input parameters
validation_result=$?

if [[ $validation_result -ne 1 ]]; then
    case ${parameters[0]} in
    1)
        cleanup_by_log "log.txt"
        ;;
    2)
        cleanup_by_date
        ;;
    3)
        cleanup_by_mask
        ;;
    esac
fi
