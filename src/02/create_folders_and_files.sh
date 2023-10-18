# #!/bin/bash

generate_list_path() {
    cd /
    directories=()
    local folder_list=$(find . -type d 2>/dev/null)
    folder_list=$(echo "$folder_list" | grep -Ev "/var|/run|/snap|/proc|/sys|/bin|/sbin")
    while IFS= read -r folder; do
        folder=${folder#.} 
        directories+=("$folder")
    done <<<"$folder_list"
}

get_random_directory() {
    local length=${#directories[@]}
    local random_index=$((RANDOM % length))
    local random_directory=${directories[random_index]}
    unset 'directories[random_index]'
    echo "$random_directory"
}

check_disk_space() {
    one_gigabyte_in_kbytes=1048576 
    local free_space=$(df -k / | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt $one_gigabyte_in_kbytes ]; then 
        echo "Недостаточно свободного места на диске!" >&2
        exit 1
    fi
}

generate_folder() {
    local quantity=$length_letters_folder
    while (check_disk_space); do
        if [ "$quantity" -eq 249 ]; then
            quantity="$length_letters_folder"
        fi
        local name=""
        for ((j = 0; j < length_letters_folder; j++)); do
            name+="${letters_folder[j]}"
        done
        while [[ $quantity -lt 4 ]]; do
            ((quantity += 1))
        done
        while [[ ${#name} -lt $quantity ]]; do
            name+="${name: -1}"
        done
        name="${name}_${current_date}"
        random_dir=$(get_random_directory)
        if cd "$random_dir" 2>/dev/null && sudo mkdir -p "$name" 2>/dev/null; then
            echo "$PWD $current_date"
            cd "$name"
            generate_files
            cd ..
            ((quantity += 1))
        else
            echo "невозмозно создать папку в пути $random_dir" >&2
        fi
    done
}

generate_files() {
    random_number=$((RANDOM % 10 + 1)) 
    for ((i = 0; i < $random_number; i++)); do
        if [ "$quantity_f" -eq 249 ]; then
            quantity_f="$length_letters_file"
        fi
        local name=""
        for ((j = 0; j < length_letters_file; j++)); do
            name+="${letters_file[j]}"
        done
        while [[ $quantity_f -lt 4 ]]; do
            ((quantity_f += 1))
        done
        while [[ ${#name} -lt $quantity_f ]]; do
            name+="${name: -1}"
        done
        name="${name}_${current_date}.${letters_file_expansion}"
        echo "$PWD/$name $current_date $file_size"
        sudo dd if=/dev/zero of="$name" bs=${file_size} count=1 >/dev/null 2>&1
        ((quantity_f += 1))
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
    local folder_letters="${1}"
    local file_letters="${2}"
    file_size=$(echo "$3" | sed 's/.$//')
    current_date=$(date +%d%m%y)
    # ----------folder---------------
    letters_folder=($(echo $folder_letters | fold -w1 | uniq)) 
    length_letters_folder=${#letters_folder[@]}
    # ----------file-----------------
    letters_file=$(get_filename "$file_letters")
    letters_file=($(echo $letters_file | fold -w1 | uniq))
    letters_file_expansion=$(get_extension "$file_letters")
    length_letters_file=${#letters_file[@]}

    generate_list_path

    # #переход в папку и вызов функций по созданию
    quantity_f=$length_letters_file
    generate_folder
}
