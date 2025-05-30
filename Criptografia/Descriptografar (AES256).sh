#!/bin/bash

# Lê os arquivos selecionados no Nautilus
readarray -t FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

# Verifica se pelo menos um arquivo foi selecionado
if [ "${#FILENAME[@]}" -eq 0 ]; then
    zenity --error --title="Erro" --text="Nenhum arquivo foi selecionado!"
    exit 1
fi

# Solicita a senha ao usuário
senha=$(zenity --password --title="Descriptografar Arquivo" --text="Digite a senha para descriptografar o arquivo:")

# Verifica se a senha foi fornecida
if [ -z "$senha" ]; then
    zenity --error --title="Erro" --text="Nenhuma senha foi fornecida!"
    exit 1
fi

# Descriptografa cada arquivo selecionado
for arquivo in "${FILENAME[@]}"; do
    # Remove a extensão .gpg para o arquivo descriptografado
    arquivo_original="${arquivo%.gpg}"

    # Descriptografa o arquivo usando gpg
    echo "$senha" | gpg --batch --yes --passphrase-fd 0 --output "$arquivo_original" --decrypt "$arquivo"

    # Verifica se a descriptografia foi bem-sucedida
    if [ $? -eq 0 ]; then
        zenity --info --title="Sucesso" --text="Arquivo '$arquivo' descriptografado com sucesso como '$arquivo_original'."
    else
        zenity --error --title="Erro" --text="Falha ao descriptografar o arquivo '$arquivo'."
    fi
done