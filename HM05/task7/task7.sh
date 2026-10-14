#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Використання: $0 <назва_файлу>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Помилка: файл не існує."
    exit 1
fi

lines=$(wc -l < "$1")
echo "Кількість рядків у файлі: $lines"
