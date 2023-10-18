validate_input() {
    local valid=0

    if [[ ${#parameters[@]} -ne 1 ]]; then
        echo "Ошибка: Неверное количество параметров!"
        valid=1
    fi

    if ! [[ ${parameters[0]} =~ ^[1-3]$ ]]; then
        echo "Ошибка: неверные параметры функции!"
        valid=1
    fi

    return $valid
}