#!/bin/bash

#Nome da aplicação
#APP_NAME="📇 Hashing"

IFS=$'\n' read -r -d '' -a FILENAME <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# Itera sobre cada arquivo
for file in "${FILENAME[@]}"; do
    # Certifica-se de que o nome do arquivo não está vazio, 
    # e remove qualquer espaço em branco de liderança/final que possa ter sobrado.
    file="$(echo -e "${file}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    if [ -z "$file" ]; then
        continue #Pula se o caminho estiver vazio
    fi

    #Notifica que a analise começou
    # notify-send "Analisando arquivo..." --app-name "$APP_NAME" #Notifica o usurio do status do script

    SHA1SUM=$( sha1sum "${file}" | awk '{print $1}' ) #cria a hash sha1
    SHA256SUM=$( sha256sum "${file}" | awk '{print $1}' ) #Cria a hash sha256
    MD5SUM=$( md5sum "${file}"  | awk '{print $1}'  ) #Cria a hash md5 
    HASH=$( zenity --entry \
    --title="Hashing" --text="Insira sua hash: " ) #Solicita a hash do arquivo ao usuario

# A hash $HASH pode estar vazia aqui.
    if [ -n "$HASH" ]; then 
    # A hash não está vazia, mas ela pode ser uma hash incompleta ou incorreta.
        zenity --info \
            --title="Analisando Hash!" \
            --text="Hash ${HASH} foi registrada."
    else
        zenity --warning \
            --title="⚠️ Aviso" \
            --text="🚫 Nem uma hash foi registrada."
        continue
    fi

    if [ "$MD5SUM" = "$HASH" ]; then #Verifica se a hash de entrada e igual a hash MD5 gerada localmente.
        zenity --info \
            --title="Comparação de hash completa!" \
            --text="A hash fornecida é identica a hash MD5 do arquivo!"
    elif [ "$SHA1SUM" = "$HASH" ]; then #Verifica se a hash de entrada e igual a hash SHA1 gerada localmente.
        zenity --info \
            --title="Comparação de hash completa!" \
            --text="A hash fornecida é identica a hash SHA1 do arquivo!"
    elif [ "$SHA256SUM" = "$HASH" ]; then #Verifica se a hash de entrada e igual a hash SHA256 gerada localmente.
        zenity --info \
            --title="Comparação de hash completa!" \
            --text="A hash fornecida é identica a hash SHA256 do arquivo!".
    else
        zenity --warning \
            --title="Comparação de hash completa!" \
            --text="A hash fornecida não é igual à hash do arquivo!\n\n⚠️ Arquivo inseguro!!! ⚠️"
    fi

done