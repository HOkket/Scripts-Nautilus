#!/bin/bash

# Lê os arquivos selecionados pelo Nautilus
readarray -t FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

# Verifica se pelo menos um arquivo foi selecionado
if [ "${#FILENAME[@]}" -eq 0 ]; then
    zenity --error --title="Erro" --text="Nenhum arquivo foi selecionado!"
    exit 1
fi

# Solicita uma senha ao usuário
senha=$(zenity --password --title="Criptografar Arquivo" --text="Digite uma senha para criptografar o arquivo:")

# Verifica se a senha foi fornecida
if [ -z "$senha" ]; then
    zenity --error --title="Erro" --text="Nenhuma senha foi fornecida!"
    exit 1
fi

# Criptografa cada arquivo selecionado
for arquivo in "${FILENAME[@]}"; do
    # Define o nome do arquivo criptografado
    arquivo_criptografado="${arquivo}.gpg"

    # Criptografa o arquivo usando gpg
    echo "$senha" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 "$arquivo"

    # Verifica se a criptografia foi bem-sucedida
    if [ $? -eq 0 ]; then
        zenity --info \
            --title="Sucesso" \
            --text="Arquivo '$arquivo' criptografado com sucesso como '$arquivo_criptografado'."
    else
        zenity --error --title="Erro" --text="Falha ao criptografar o arquivo '$arquivo'."
    fi
done