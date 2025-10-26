#!/bin/bash

#Captura o arquivo selecionado no nautilus
readarray FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

# Itera sobre cada arquivo
for file in "${FILENAME[@]}"; do
    # Certifica-se de que o nome do arquivo não está vazio, 
    # e remove qualquer espaço em branco de liderança/final que possa ter sobrado.
    file="$(echo -e "${file}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [ -z "$file" ]; then
        continue # Pula se o caminho estiver vazio
    fi

    #Verifica se o arquivo selecionado e uma imagem
    file=$(echo "$file" | tr -d $'\n')
    if file "$file" | grep -qE 'image|bitmap'; then
        convert "$file" "${file%.*}-converted.jpg" #converte e imagem para jpg
        zenity --info \
            --title="✅ Conversor ✅" \
            --text="O arquivo foi convertido para JPG."
    else
        zenity --error \
            --title="Conversor falhou!" \
            --text="O arquivo fornecido não é uma imagem valida!" #Informa que o arquivo fornecido não e valido para a operação
        #notify-send "Erro" "O arquivo $file não é uma imagem." --app-name="Conversor"
        #exit 1
    fi

done