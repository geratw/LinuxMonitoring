#!/bin/bash

validate_input() {
    if [[ ${#parameters[@]} -ne 1 ]]; then
        echo "Неверное количество параметров."
        return 1
    fi

    # Проверка валидности переданного номера запроса
    if ! [[ ${parameters[0]} =~ ^[1-4]$ ]]; then
        echo "Неверное значение параметра. Укажите 1, 2, 3 или 4."
        return 1
    fi
}
