#!/bin/bash

cleanup_by_log() {
    local file="$1"
    while IFS= read -r line; do
        local elements=($line)
        local num_elements=${#elements[@]}
        if ((num_elements == 3)); then
            local file_to_delete=${elements[0]}
            if [[ -e "$file_to_delete" ]]; then
                sudo rm -rf "$file_to_delete"
                echo "Deleted file: $file_to_delete"
            else
                echo "File not found: $file_to_delete"
            fi
        elif ((num_elements == 2)); then
            local dir_path=${elements[0]}
            if [[ -d "$dir_path" ]]; then
                sudo rm -rf "$dir_path"
                echo "Deleted directory: $dir_path"
            else
                echo "Directory not found: $dir_path"
            fi
        else
            echo "Invalid line format: $line"
        fi
    done <"$file"
}

validate_datetime_format() {
    local prompt=$1
    local datetime_variable=$2
    local datetime_pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$"
    while true; do
        read -p "$prompt: " datetime
        if [[ ! $datetime =~ $datetime_pattern ]]; then
            echo "Неправильный формат даты и времени. Повторите ввод."
        else
            eval "$datetime_variable=\"$datetime\""
            break
        fi
    done
}

cleanup_by_date() {
    validate_datetime_format "Введите начало временного интервала (YYYY-MM-DD HH:MM)" start_time
    validate_datetime_format "Введите конец временного интервала (YYYY-MM-DD HH:MM)" end_time

    # Получить список файлов и каталогов
    local file_list=$(sudo find / -type f -newerct "$start_time" ! -newerct "$end_time" 2>/dev/null)
    local dir_list=$(sudo find / -type d -newerct "$start_time" ! -newerct "$end_time" 2>/dev/null)

    file_list=$(echo "$file_list" | grep -Ev "/var|/run|/snap|/proc|/sys|/bin|/sbin")
    dir_list=$(echo "$dir_list" | grep -Ev "/var|/run|/snap|/proc|/sys|/bin|/sbin")
    if [[ -n "$file_list" ]]; then
        while IFS= read -r file_path; do
            if [[ -e "$file_path" ]]; then
                # if sudo rm -f "$file_path" 2>/dev/null; then
                echo "Deleted file: $file_path"
                # fi
            fi
        done <<<"$file_list" 
    fi

    if [[ -n "$dir_list" ]]; then
        while IFS= read -r dir_path; do
            if [[ -d "$dir_path" ]]; then
                # if sudo rm -f "$dir_path" 2>/dev/null; then
                echo "Deleted directory: $dir_path"
                # fi
            fi
        done <<<"$dir_list"
    fi
}

cleanup_by_mask() {
    read -p "Введите маску имени для удаления: " mask

    # Получаем список папок и файлов, соответствующих маске имени
    local paths=$(find / -name "$mask" 2>/dev/null)

    if [[ -n "$paths" ]]; then
        while IFS= read -r path; do
            if [[ -d "$path" ]]; then
                sudo rm -rf "$path"
                echo "Deleted folder: $path"
            elif [[ -f "$path" ]]; then
                sudo rm "$path"
                echo "Deleted file: $path"
            else
                echo "Path not found: $path"
            fi
        done <<<"$paths"
    else
        echo "Не найдено путей, соответствующих маске: $mask"
    fi
}
