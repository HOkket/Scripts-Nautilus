#!/bin/bash

# 1. Captura os caminhos dos arquivos selecionados
# O Nautilus entrega os caminhos separados por quebras de linha
IFS=$'\n' read -rd '' -a FILES <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# 2. Pergunta o nome do PDF apenas UMA vez
NOME_PDF=$(zenity --entry \
    --title="Nome para o arquivo PDF" \
    --text="Insira o nome para o PDF final (sem extensão):" \
    --entry-text="resultado")

# Se o usuário cancelar ou não digitar nada, encerra o script
if [ -z "$NOME_PDF" ]; then exit 1; fi

# 3. Criar uma lista de arquivos válidos
VALID_IMAGES=()
for file in "${FILES[@]}"; do
    # Remove caracteres invisíveis e espaços extras
    file=$(echo "$file" | tr -d '\r\n')
    
    if [ -f "$file" ] && file --mime-type "$file" | grep -qE 'image/'; then
        VALID_IMAGES+=("$file")
    fi
done

# 4. Verifica se existem imagens válidas e converte tudo de uma vez
if [ ${#VALID_IMAGES[@]} -gt 0 ]; then
    # O comando convert do ImageMagick aceita múltiplos arquivos de entrada
    convert "${VALID_IMAGES[@]}" "$NOME_PDF.pdf"
    
    zenity --info \
        --title="✅ Conversor ✅" \
        --text="Sucesso! ${#VALID_IMAGES[@]} imagens foram unidas em: $NOME_PDF.pdf"
else
    zenity --error \
        --title="Conversor falhou!" \
        --text="Nenhuma imagem válida foi selecionada."
fi