#!/bin/bash

# Captura os arquivos selecionados
readarray -t FILENAMES <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

for file in "${FILENAMES[@]}"; do
    # Limpeza básica do caminho
    file=$(echo "$file" | sed -e 's/\r//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    
    if [ -z "$file" ]; then
        continue
    fi

    # --- VERIFICAÇÃO SE É PDF ---
    # O comando 'file --mime-type' retorna 'application/pdf' para PDFs reais
    if file --mime-type "$file" | grep -q 'application/pdf'; then
        
        # Extrai as imagens do PDF usando pdftoppm
        # %.* remove a extensão original para não ficar "arquivo.pdf-extraido"
        pdftoppm -png -r 300 "$file" "${file%.*}-extraido"
        
        zenity --info \
            --title="✅ Sucesso ✅" \
            --text="As imagens do PDF '$file' foram extraídas."
    else
        zenity --error \
            --title="Erro de Formato" \
            --text="O arquivo '$file' não é um PDF válido!"
    fi
done