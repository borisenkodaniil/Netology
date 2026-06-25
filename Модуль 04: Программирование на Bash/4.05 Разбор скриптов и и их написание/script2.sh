#!/bin/bash
#Имя пользователя, от которого должен запускаться скрипт:
ROOTUSER_NAME=root

PREFIX="${1:-NOT_SET}"
INTERFACE="$2"
SUBNET="$3"
HOST="$4"

#Обработка Ctrl+C
trap 'echo "Отработка прерывания (Ctrl-C)"; exit 1' 2


#Проверка запуска скрипта от root
username=`id -nu`
if [ "$username" != "$ROOTUSER_NAME" ]
then
        echo "Скрипт должен быть запущен с правами root  \"`basename $0`\"."
        exit 1
fi

[[ "$PREFIX" = "NOT_SET" ]] && {
    echo "\$PREFIX Должен быть указан первым аргументом"
    exit 1
}

#Проверка формата PREFIX и присвоение октетам переменных A и B
if [[ "$PREFIX" =~ ^([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
    A="${BASH_REMATCH[1]}"
    B="${BASH_REMATCH[2]}"
else
    echo "PREFIX Должен быть указан в формате xxx.xxx"
    exit 1
fi

#Задаем диапазоны октет PREFIX от 0 до 255
if (( A < 0 || A > 255 || B < 0 || B > 255 )); then
    echo "Диапазоны октет PREFIX должны быть от 0 до 255"
    exit 1
fi

#Проверка INTERFACE
if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE должен быть указан вторым аргументом"
    exit 1
fi


#Функция валидации октетов
validate_octet() {
    local name="$1"
    local value="$2"

    #Проверка формата
    if [[ -n "$value" && ! "$value" =~ ^[0-9]{1,3}$ ]]; then
        echo "$name должен быть указан в формате числа"
        exit 1
    fi

    #Проверка диапазона
    if [[ -n "$value" ]]; then
        if (( value < 0 || value > 255 )); then
            echo "$name должен быть указан в диапазоне от 0 до 255"
            exit 1
        fi
    fi
}

#Проверка SUBNET и HOST через функцию
validate_octet "SUBNET" "$SUBNET"
validate_octet "HOST" "$HOST"

#Если SUBNET не передан, сканируем все подсети
if [[ -z "$SUBNET" ]]; then
    echo "SUBNET не указана, сканируется вся подсеть от 0 до 255"
    SUBNET="$(seq 0 255)"
fi

#Если HOST не передан, сканируем все хосты
if [[ -z "$HOST" ]]; then
    echo "HOST не указан, сканируются все хосты от 0 до 255"
    HOST="$(seq 0 255)"
fi

#Переменные S и H принадлежат переменной $SUBNET и $HOST
for S in $SUBNET
do
        for H in $HOST
        do
                echo "[*] IP : ${PREFIX}.${S}.${H}"
                arping -c 3 -i "$INTERFACE" "${PREFIX}.${S}.${H}" 2> /dev/null
        done
done

