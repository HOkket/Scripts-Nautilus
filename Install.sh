#!/bin/bash

# Diretório de destino para os scripts do Nautilus
DEST_DIR="$HOME/.local/share/nautilus/scripts"

# Verifica se o diretório de destino existe, caso contrário, cria
if [ ! -d "$DEST_DIR" ]; then
    echo "Criando diretório: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copia os scripts para o diretório de destino
echo "Copiando scripts para $DEST_DIR..."
cp -r ./*.sh "$DEST_DIR"

# Torna todos os scripts executáveis
echo "Tornando os scripts executáveis..."
chmod +x "$DEST_DIR"/*.sh

# Atualiza os scripts do Nautilus
echo "Atualizando os scripts do Nautilus..."
nautilus -q

echo "Instalação concluída! Os scripts estão disponíveis no menu de contexto do Nautilus."