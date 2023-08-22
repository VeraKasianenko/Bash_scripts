#!/bin/bash

# Проверка аргументов
if [ $# -ne 3 ]; then
    echo "Usage: $0 <old_username> <new_username> <path>"
    exit 1
fi

old_username="$1"
new_username="$2"
path="$3"

# Проверка существования пути
if [ ! -e "$path" ]; then
    echo "Path not found: $path"
    exit 1
fi

# Проверка существования старого пользователя
if ! id "$old_username" &>/dev/null; then
    echo "User not found: $old_username"
    exit 1
fi

# Проверка существования нового пользователя
if ! id "$new_username" &>/dev/null; then
    echo "User not found: $new_username"
    exit 1
fi

# Функция для рекурсивной смены владельца и прав доступа
change_ownership_and_permissions() {
    local item="$1"
    local old_owner="$2"
    local new_owner="$3"
    
    # Получить тип элемента (файл, папка и т.д.)
    item_type=$(stat -c "%F" "$item")

    # Изменить владельца и права доступа
    chown "$new_owner" "$item"
    chmod 755 "$item"
    
    # Рекурсивная обработка только для папок
    if [ "$item_type" = "directory" ]; then
        for sub_item in "$item"/* "$item"/.[!.]* "$item"/..?*; do
            if [ -e "$sub_item" ]; then
                change_ownership_and_permissions "$sub_item" "$old_owner" "$new_owner"
            fi
        done
    fi
}

# Вызов функции для изменения владельца и прав доступа
change_ownership_and_permissions "$path" "$old_username" "$new_username"
echo "Ownership and permissions changed for files and folders in $path owned by $old_username to $new_username and permissions"

