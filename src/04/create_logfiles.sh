#!/bin/bash

random_number() {
    local min=$1
    local max=$2
    echo $((RANDOM % (max - min + 1) + min))
}

date="$(date +%Y)-$(date +%m)-$(date +%d) 00:00:00 $(date +%z)"

seconds=$(random_number 10 60)

response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")

request_methods=("GET" "POST" "PUT" "PATCH" "DELETE")

user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

greate_log() {
    for ((i = 1; i <= 5; i++)); do
        log_file="access_log_$i.log"
        echo "Генерация лога: $log_file"

        num_entries=$(random_number 100 1000)

        for ((j = 1; j <= num_entries; j++)); do
            ip_address=$(random_number 1 255).$(random_number 1 255).$(random_number 1 255).$(random_number 1 255)
            response_code=${response_codes[$(random_number 0 ${#response_codes[@]}-1)]}
            request_method=${request_methods[$(random_number 0 ${#request_methods[@]}-1)]}
            date_time="[$(date -d "$date + $seconds seconds" +'%d/%b/%Y:%H:%M:%S %z')] "
            url="/page$(random_number 1 10).html"
            user_agent=${user_agents[$(random_number 0 ${#user_agents[@]}-1)]}

            echo "$ip_address - - $date_time\"$request_method $url HTTP/1.1\" $response_code - \"$user_agent\"" >> "$log_file"
            seconds=$((seconds + $(random_number 10 60)))
        done

        echo "Сгенерировано $num_entries записей в логе."
        echo
    done
}
