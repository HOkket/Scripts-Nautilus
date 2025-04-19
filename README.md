# Scripts-Nautilus

Este repositório contém scripts personalizados para integração com o Nautilus, o gerenciador de arquivos do GNOME. Os scripts foram projetados para automatizar tarefas comuns e melhorar a produtividade ao usar o ambiente de desktop GNOME.

## Funcionalidades

- Scripts para automação de tarefas no Nautilus.
- Integração simples e fácil de configurar.
- Personalizável para atender às suas necessidades.
- Instalação automatizada através do script `install.sh`.

## Pré-requisitos

Certifique-se de que as seguintes dependências estão instaladas no seu sistema antes de usar os scripts:

- [Zenity](https://help.gnome.org/users/zenity/stable/): Para criar diálogos gráficos.
- [FFmpeg](https://ffmpeg.org/): Para manipulação de arquivos de mídia.
- [ImageMagick](https://imagemagick.org/): Para edição e conversão de imagens.
- Outras dependências específicas podem ser mencionadas nos scripts individuais.

Você pode instalar essas dependências usando o gerenciador de pacotes da sua distribuição.

## Como usar

### Instalação Manual

1. Clone este repositório:
    ```bash
    git clone https://github.com/HOkket/Scripts-Nautilus
    ```
2. Copie os scripts para o diretório de scripts do Nautilus:
    ```bash
    cp -r Scripts-Nautilus/* ~/.local/share/nautilus/scripts/
    ```
3. Certifique-se de que os scripts têm permissão de execução:
    ```bash
    find ~/.local/share/nautilus/scripts/ -type f -exec chmod +x {} +
    ```

### Instalação Automatizada

1. Clone este repositório:
    ```bash
    git clone https://github.com/HOkket/Scripts-Nautilus
    ```
2. Execute o script de instalação:
    ```bash
    cd Scripts-Nautilus
    ./install.sh
    ```

4. Acesse os scripts clicando com o botão direito em um arquivo ou pasta no Nautilus e navegando até o menu "Scripts".

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).