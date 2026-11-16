
#!/bin/bash

secret=$((RANDOM % 100 + 1))
max_attempts=5

echo "Я загадав число від 1 до 100. У вас є $max_attempts спроб."

for ((attempt = 1; attempt <= max_attempts; attempt++)); do
    read -p "Спроба $attempt/$max_attempts - введіть число: " guess

    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Будь ласка, введіть ціле число."
        ((attempt--))
        continue
    fi

    if [ "$guess" -eq "$secret" ]; then
        echo "Вітаю! Ви вгадали число."
        exit 0
    elif [ "$guess" -gt "$secret" ]; then
        echo "Забагато"
    else
        echo "Замало"
    fi
done

echo "На жаль, спроби закінчилися. Загадане число було $secret"
