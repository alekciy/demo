#!/usr/bin/env bash

# Ищет свободный loopback интерфейс который по сути будет использоваться как пространство для развертывания
# docker-ов проекта на стандартных для сервисов портах

# Ищем свободный интерфейс
for i in `seq 1 254`; do
  for port in $PORT_LIST; do
    netstat -ln | grep "127.0.1.${i}:${port} " 1>/dev/null
    if [ $? -eq 0 ]; then
      continue 2
    fi
  done

  echo -n "127.0.1.${i}"
  exit 0
done

exit 1
