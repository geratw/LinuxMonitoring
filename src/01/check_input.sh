#!/bin/bash

# Проверка корректности ввода параметров
validate_input() {
    local root_dir="${1}"
    local num_folders="${2}"
    local folder_letters="${3}"
    local num_files="${4}"
    local file_letters="${5}"
    local file_size="${6}"
    local valid=0

    if [[ ${#parameters[@]} -ne 6 ]]; then
        echo "Ошибка: Неверное количество параметров!"
        valid=1
    fi


    if [[ ! "$num_folders" =~ ^[0-9]+$ ]] || [[ ! "$num_files" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: Некорректный формат параметров '$num_folders' или '$num_files'!"
        valid=1
    fi

    if [[ -z "$root_dir" ]]; then
        echo "Путь не указан."
        valid=1
    fi

    if [[ ! "$root_dir" =~ ^[a-zA-Z0-9_/]+$ ]]; then
        echo "Некорректный путь. Путь может содержать только буквы, цифры и символы / и _."
        valid=1
    fi

    if ! [[ "$folder_letters" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "'$folder_letters' Некорректное имя папки!"
        valid=1
    fi

    if ! [[ "$file_letters" =~ ^[A-Za-z]{1,7}(\.[A-Za-z]{1,3})?$ ]]; then
        echo "'$file_letters' Некорректное имя файла!"
        valid=1
    fi

    if ! [[ "$file_size" =~ ^(0|[1-9][0-9]?|100)kb$ ]]; then
        echo "'$file_size' Некорректный формат размера файла!"
        valid=1
    fi

    return "$valid"
}
