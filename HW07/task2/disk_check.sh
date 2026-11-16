#!/bin/bash


PORIG=$1


LOG_FILE="/var/log/disk.log"


if ! [[ "$PORIG" =~ ^[0-9]+$ ]] || [ "$PORIG" -lt 1 ] || [ "$PORIG" -gt 100 ]; then
    echo "Помилка: поріг повинен бути числом від 1 до 100."
    exit 1
fi


VYKORISTANNYA=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')


if [ "$VYKORISTANNYA" -gt "$PORIG" ]; then
    # Записуємо попередження до журналу
    echo "$(date '+%Y-%m-%d %H:%M:%S') ПОПЕРЕДЖЕННЯ: використання кореневого розділу становить ${VYKORISTANNYA}%, що перевищує поріг ${PORIG}%." >> "$LOG_FILE"
fi
