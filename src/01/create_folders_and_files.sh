#!/bin/bash

check_disk_space() {
    one_gigabyte_in_bytes=1048576 
    local free_space=$(df -k / | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt $one_gigabyte_in_bytes ]; then 
        echo "Недостаточно свободного места на диске!" >&2
        exit 1
    fi
}

generate_folder() {
    local quantity_letters_folder=$length_letters_folder
    for ((z = 0; z < num_folders; z++)); do
        if [ "$quantity_letters_folder" -eq 249 ]; then
            quantity_letters_folder="$length_letters_folder"
        fi
        local name_dir=""
        for ((j = 0; j < length_letters_folder; j++)); do
            name_dir+="${letters_folder[j]}"
        done
        while [[ $quantity_letters_folder -lt 4 ]]; do
            ((quantity_letters_folder += 1))
        done
        while [[ ${#name_dir} -lt $quantity_letters_folder ]]; do
            name_dir+="${name_dir: -1}"
        done
        name_dir="${name_dir}_${current_date}"
        if sudo mkdir "$name_dir" 2>/dev/null; then
            cd "$name_dir"
            generate_files
            echo "$PWD $current_date"
            cd ..
        else
            echo "невозмозно создать папку в пути $PWD, укажите другой путь" >&2
            exit 1
        fi
        ((quantity_letters_folder += 1))
    done
}

generate_files() {
    for ((i = 0; i < num_files; i++)); do
        if [ "$quantity_letters_file" -eq 249 ]; then
            quantity_letters_file="$length_letters_file"
        fi
        local name_file=""
        for ((j = 0; j < length_letters_file; j++)); do
            name_file+="${letters_file[j]}"
        done
        while [[ $quantity_letters_file -lt 4 ]]; do
            ((quantity_letters_file += 1))
        done
        while [[ ${#name_file} -lt $quantity_letters_file ]]; do
            name_file+="${name_file: -1}"
        done
        name_file="${name_file}_${current_date}.${letters_file_expansion}"
        echo "$PWD/$name_file $current_date $file_size"
        sudo dd if=/dev/zero of="$name_file" bs=${file_size} count=1 >/dev/null 2>&1
        ((quantity_letters_file += 1))
        check_disk_space
    done
}

get_filename() {
    local filename="$1"
    local basename="${filename%%.*}"
    echo "$basename"
}

get_extension() {
    local filename="$1"
    local extension="${filename##*.}"
    echo "$extension"
}

create_folders_and_files() {
    num_folders=$2
    name_folder=$3
    num_files=$4
    name_files=$5
    file_size=$(echo "$6" | sed 's/.$//')
    current_date=$(date +%d%m%y)
    # ----------folder---------------
    letters_folder=($(echo $name_folder | fold -w1 | uniq))
    length_letters_folder=${#letters_folder[@]}

    # ----------file-----------------
    letters_file=($(echo $(get_filename "$5") | fold -w1 | uniq))
    letters_file_expansion=$(get_extension "$5")
    length_letters_file=${#letters_file[@]}

    #переход в папку и вызов функций по созданию
    cd "${parameters[0]}"
    quantity_letters_file=$length_letters_file
    generate_folder
}
