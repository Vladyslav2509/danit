#!/bin/bash

WATCH_DIR="$HOME/watch"

mkdir -p "$WATCH_DIR"

echo "Моніторинг директорії: $WATCH_DIR"

while true; do
    for file in "$WATCH_DIR"/*; do
        
	[[ "$file" == *.back ]] && continue
        
	echo "Знайдено новий файл: $(basename "$file")"
        echo "Вміст файлу:"
        cat "$file"
        
	mv "$file" "$file.back"

        echo "Файл перейменовано: $(basename "$file").back"
        echo "-------------------------"
    done
    
    sleep 2
done
