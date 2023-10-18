#!/bin/bash

monitoring() {
    case $1 in
    1)
        # Все записи, отсортированные по коду ответа
        for ((i = 0; i < ${#log_files[@]}; i++)); do
            echo "Результат сортировки для ${log_files[$i]}:"
            sort -k 9 "${log_files[$i]}"
        done
        ;;
    2)
        # Все уникальные IP, встречающиеся в записях
        for ((i = 0; i < ${#log_files[@]}; i++)); do
            echo "Уникальные IP для ${log_files[$i]}:"
            awk '{print $1}' "${log_files[$i]}" | sort -u
        done
        ;;
    3)
        # Все запросы с ошибками (код ответа - 4хх или 5хх)
        for ((i = 0; i < ${#log_files[@]}; i++)); do
            echo "Запросы с ошибками для ${log_files[$i]}:"
            awk '$9 ~ /^[45]/' "${log_files[$i]}"
        done
        ;;
    4)
        # Все уникальные IP, которые встречаются среди ошибочных запросов
        for ((i = 0; i < ${#log_files[@]}; i++)); do
            echo "Уникальные IP среди ошибочных запросов для ${log_files[$i]}:"
            awk '$9 ~ /^[45]/ {print $1}' "${log_files[$i]}" | sort -u
        done
        ;;
    esac
}
