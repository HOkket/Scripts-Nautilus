#!/bin/bash

# Verifica se o diretório de destino existe, caso contrário, cria
if [ ! -d "$DEST_DIR" ]; then
    echo "Criando diretório: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi
cp -r Scripts-Nautilus/* ~/.local/share/nautilus/scripts/



# Atualiza os scripts do Nautilus
echo "Atualizando os scripts do Nautilus..."
nautilus -q

echo "Instalação concluída! Os scripts estão disponíveis no menu de contexto do Nautilus."