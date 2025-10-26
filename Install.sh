#!/bin/bash

# Define o diretório de destino
DEST_DIR="$HOME/.local/share/nautilus/scripts"

# Verifica se o diretório de destino existe, caso contrário, cria
if [ ! -d "$DEST_DIR" ]; then
    echo "Criando diretório: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copia os scripts para o diretório de destino
echo "Copiando scripts para $DEST_DIR..."
cp -r Segurança/ Audio/ Imagens/ Videos/ Criptografia\ \(teste\)/ "$DEST_DIR"

# Torna todos os scripts executáveis
echo "Tornando os scripts executáveis..."
find "$DEST_DIR" -type f -name "*.sh" -exec chmod +x {} +

# Atualiza os scripts do Nautilus
echo "Atualizando os scripts do Nautilus..."
if pgrep -x "nautilus" > /dev/null; then
    echo "Reiniciando o Nautilus..."
    nautilus -q
else
    echo "Nautilus não está em execução. Por favor, reinicie-o manualmente para aplicar as alterações."
fi

echo "Instalação concluída! Os scripts estão disponíveis no menu de contexto do Nautilus."
echo "Para acessar o menu de contexto, clique com o botão direito em um arquivo ou pasta no Nautilus. Saiba mais em: https://help.gnome.org/users/nautilus/stable/"