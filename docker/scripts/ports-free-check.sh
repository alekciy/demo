#!/usr/bin/env bash

# Проверяем свободность необходимых портов в принципе.
for port in $PORT_LIST; do
    netstat -ln | grep "0.0.0.0:${port} " 1>/dev/null
    if [ $? -eq 0 ]; then
        echo "Работа невозможна, остановите службу висящую на 0.0.0.0:${port} порту"
        exit 1
        break
    fi
done

# Ищет свободный loopback интерфейс который по сути будет использоваться как пространство для развертывания
# docker-ов проекта на стандартных для сервисов портах
# Ищем свободный интерфейс
PORT_LIST="${PORT_LIST}" $(dirname "$0")/get-free-interface.sh 1>/dev/null
if [ $? -eq 1 ]; then
    echo "Работа невозможна, нет ни одного свободного 127.0.0.* интерфейса"
    exit 1
fi
