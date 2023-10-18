#!/bin/bash

chmod +x create_logfiles.sh

. ./create_logfiles.sh

if [ $# != 0 ]; then
    echo "Недопустимое количество аргументов (должно быть равно 0)"
else
    greate_log
fi


# 200: Успешный запрос (OK)
# 201: Создан новый ресурс (Created)
# 400: Некорректный запрос (Bad Request)
# 401: Требуется аутентификация (Unauthorized)
# 403: Доступ запрещен (Forbidden)
# 404: Ресурс не найден (Not Found)
# 500: Внутренняя ошибка сервера (Internal Server Error)
# 501: Не реализовано (Not Implemented)
# 502: Некорректный ответ от сервера (Bad Gateway)
# 503: Сервис недоступен (Service Unavailable)