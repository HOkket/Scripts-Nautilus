#!/bin/bash

readarray FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

for file in "${FILENAME[@]}"; do
    file=$(echo "$file" | tr -d $'\n')
    if file "$file" | grep -qE 'audio|media'; then
        # Obter duração total do áudio
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
        
        # Converter para MP3 com qualidade 320k
        ffmpeg -i "$file" -c:a libmp3lame -b:a 320k "${file%.*}-converted.mp3" 2>&1 | \
        while read -r line; do
            if [[ $line =~ time=([0-9:.]+) ]]; then
                current_time=$(echo "${BASH_REMATCH[1]}" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
                progress=$(( (current_time * 100) / duration ))
                echo "$progress" #Captura a duração da converção
            fi
        done | zenity --progress \
            --title="Convertendo Áudio" \
            --text="Convertendo $file..." \
            --percentage=0 \
            --auto-close #Informa que a conversão ocorreu com sucesso
    else
        # Informa que o arquivo fornecido não e um audio.
        zenity --error \
            --title="Conversor" \
            --text="O arquivo $file não é um áudio."
    fi

done
