#!/bin/bash

read -p "Введіть речення: " sentence

read -ra words <<< "$sentence"

reversed=""
for ((i = ${#words[@]} - 1; i >= 0; i--)); do
    reversed+="${words[i]} "
done

echo "Речення у зворотному порядку: ${reversed% }"
