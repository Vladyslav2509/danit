#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Помилка: вкажіть назву файлу."
    echo "Використання: $0 <назва_файлу>"
    exit 1
fi

if [ -f "$1" ]; then
    echo "Вміст файлу:"
    cat "$1"
else
    echo "Помилка: файл не існує."
    exit 1
fi
