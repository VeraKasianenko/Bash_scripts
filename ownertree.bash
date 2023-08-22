#!/bin/bash

# Функция для рекурсивного вывода дерева файлов
print_tree() {
    local indent="$1"
    local dir="$2"
    
    # Получить информацию о текущем элементе
    info=$(stat -c "%U %G %a" "$dir")
    owner=$(echo "$info" | awk '{print $1}')
    group=$(echo "$info" | awk '{print $2}')
    permissions=$(echo "$info" | awk '{print $3}')
    
    echo "$indent|-- $dir (Owner: $owner, Group: $group, Permissions: $permissions)"
    
    # Рекурсивный обход подпапок
    if [ -d "$dir" ]; then
        for item in "$dir"/*; do
            if [ -e "$item" ]; then
                print_tree "$indent|   " "$item"
            fi
        done
    fi
}

# Проверка наличия аргумента (начальной директории)
if [ -z "$1" ]; then
    start_dir="."
else
    start_dir="$1"
fi

# Вызов функции для вывода дерева файлов
print_tree "" "$start_dir"

