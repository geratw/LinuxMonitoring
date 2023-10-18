#!/bin/bash
chmod +x check_input.sh
chmod +x create_folders_and_files.sh

. ./check_input.sh
. ./create_folders_and_files.sh

parameters=($@)
check_disk_space
validate_input "${parameters[@]}"
validation_result=$?
log_file="$PWD/log.txt"

if [[ $validation_result -ne 1 ]]; then
    sudo mkdir -p "${parameters[0]}"
    create_folders_and_files "${parameters[@]}" > "$log_file"
fi

