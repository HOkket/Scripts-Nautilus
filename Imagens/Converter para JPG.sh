#!/bin/bash

{

readarray FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

for file in "${FILENAME[@]}"; do
    file=$(echo "$file" | tr -d $'\n')
    if file "$file" | grep -qE 'image|bitmap'; then
        convert "$file" "${file%.*}-converted.jpg"
    else
        notify-send "Erro" "O arquivo $file não é uma imagem." --app-name="Conversor"
    fi
done

notify-send "Deu certo!" "Os arquivos foram convertidos para JPG." --app-name="Conversor"

}
