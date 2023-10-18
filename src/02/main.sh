#!/bin/bash
chmod +x check_input.sh
chmod +x create_folders_and_files.sh

. ./check_input.sh
. ./create_folders_and_files.sh

parameters=($@)
log_file="$PWD/log.txt"

validate_input "${parameters[@]}"
validation_result=$?

if [[ $validation_result -ne 1 ]]; then
    create_folders_and_files "${parameters[@]}" > "$log_file"
fi

