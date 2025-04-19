#!/bin/bash

{
readarray FILENAME <<< "$(echo -e "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed -e 's/\r//g')"

for file in "${FILENAME[@]}"; do
    file=$(echo "$file" | tr -d $'\n')
    if ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$file" | grep -q 'video'; then
        # Obter duração total do vídeo
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
        
        # Converter com barra de progresso
        ffmpeg -i "$file" -c:v prores -profile:v 3 -c:a pcm_s16le "${file%.*}-converted.mov" 2>&1 | \
        while read -r line; do
            if [[ $line =~ time=([0-9:.]+) ]]; then
                current_time=$(echo "${BASH_REMATCH[1]}" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
                progress=$(( (current_time * 100) / duration ))
                echo "$progress"
            fi
        done | zenity --progress \
            --title="Convertendo Vídeo" \
            --text="Convertendo $file..." \
            --percentage=0 \
            --auto-close
    else
        notify-send "Erro" "O arquivo $file não é um vídeo." --app-name="Conversor"
        exit 1
    fi
done

notify-send "Deu certo!" "Os arquivos foram convertidos para MOV." --app-name="Conversor"
}
