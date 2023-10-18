#!/bin/bash

chmod +x script_for_parsing_logs.sh
chmod +x check_input.sh

. ./script_for_parsing_logs.sh
. ./check_input.sh

log_files=("access_log_1.log" "access_log_2.log" "access_log_3.log" "access_log_4.log" "access_log_5.log")

cd ../04

# Проверка количества переданных аргументов
parameters=($@)
validate_input "${parameters[@]}"
validation_result=$?

if [[ $validation_result -ne 1 ]]; then
monitoring $1 "${log_files[@]}"
fi