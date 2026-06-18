#!/bin/bash

# Captura os arquivos selecionados no Nautilus (separados por quebra de linha)
# O readarray -t remove automaticamente a quebra de linha de cada item
readarray -t FILES <<<"$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# Variáveis para controle de sucesso/erro
success_count=0
error_count=0

# Itera sobre cada arquivo
for file in "${FILES[@]}"; do
    # Remove espaços em branco extras nas pontas (opcional, mas mantido por segurança)
    file=$(echo "$file" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Pula se o caminho estiver vazio
    if [ -z "$file" ]; then
        continue
    fi

    # Verifica se o arquivo selecionado existe e é uma imagem
    if [ -f "$file" ] && file --mime-type "$file" | grep -qE 'image/'; then

        # Correção do comando de upscale (removida a palavra "imagem" duplicada)
        # Ajuste o nome do comando se a sua ferramenta CLI tiver outro nome (ex: upscale-cli)
        upscale image -i "$file" -o "${file%.*}-upscaling.jpg" -a realesrgan -m normal -s 4 -q 3

        # Incrementa o contador de sucesso
        ((success_count++))
    else
        # Incrementa o contador de erro se não for uma imagem válida
        ((error_count++))
    fi
done

# Exibe o feedback final ao usuário fora do loop (evita spam de janelas)
if [ "$success_count" -gt 0 ] && [ "$error_count" -eq 0 ]; then
    zenity --info \
        --title="✅ Upscaler ✅" \
        --text="Sucesso! $success_count imagem(ns) foram processada(s)."
elif [ "$success_count" -gt 0 ] && [ "$error_count" -gt 0 ]; then
    zenity --warning \
        --title="⚠️ Upscaler Concluído com Avisos ⚠️" \
        --text="Processadas: $success_count imagem(ns).\nFalhas/Ignorados: $error_count arquivo(s)."
elif [ "$error_count" -gt 0 ]; then
    zenity --error \
        --title="❌ Upscaler falhou! ❌" \
        --text="Nenhum arquivo válido de imagem foi encontrado."
fi
