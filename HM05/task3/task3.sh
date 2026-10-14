#!/bin/bash

echo "Введіть назву файлу"
read filename
if [ -f "$filename" ]; then
	echo "Файл існує".
else	
	echo "Файл не існує".
fi
