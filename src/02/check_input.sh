validate_input() {
    local folder_letters="${1}"
    local file_letters="${2}"
    local file_size="${3}"
    local valid=0
    if [[ ${#parameters[@]} -ne 3 ]]; then
        echo "Ошибка: Неверное количество параметров!"
        valid=1
    fi

    if [[ ! "$folder_letters" =~ ^[a-zA-Z]{1,7}$ ]]; then
        echo "Ошибка: Некорректное имя папки!"
        valid=1
    fi

    if [[ ! "$file_letters" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "Ошибка: Некорректное имя файла и расширение!"
        valid=1
    fi

    if ! [[ $file_size =~ ^(0|[1-9][0-9]?|100)Mb$ ]]; then
        echo "Ошибка: Некорректный формат размера файла!"
        valid=1
    fi

    return $valid
}
