#!/home/mateusferreira/Documentos/my_rembg/venv/bin/python3
# Na primeira linha deve ser definido o caminho do interpretador Python do seu ambiente virtual
# Programa para tratamento de arquivos de assinatura

import os
import subprocess
from plyer import notification
from rembg import remove, new_session


def enviar_notificacao(titulo, mensagem="Cartorio..."):
    """Envia uma notificação visual para o sistema desktop."""
    try:
        # Correção: Adicionado o parêntese de fechamento no final da função notify
        notification.notify(
            title=titulo, message=mensagem, app_name="Cartorio", timeout=5
        )
    except Exception as e:
        # Em vez de apenas passar, avisa no terminal se houver erro (ajuda a descobrir se falta o libnotify no Linux)
        print(f"Erro ao enviar notificação: {e}")


def main():
    # 1. ESCOLHA SEU MODELO AQUI
    NOME_DO_MODELO = "isnet-general-use"

    # 2. Inicializa a sessão com o modelo escolhido ANTES do laço for
    try:
        sessao_ia = new_session(NOME_DO_MODELO, providers=["CUDAExecutionProvider"])
    except Exception as e:
        enviar_notificacao(
            "Erro no Script", f"Não foi possível carregar o modelo {NOME_DO_MODELO}"
        )
        return

    # 3. Captura a string com os caminhos dos arquivos do Nautilus
    arquivos_string = os.environ.get("NAUTILUS_SCRIPT_SELECTED_FILE_PATHS", "")
    lista_arquivos = arquivos_string.strip().split("\n")

    if not lista_arquivos or lista_arquivos == [""]:
        enviar_notificacao("Assinaturas", "Nenhum arquivo selecionado.")
        return

    sucessos = 0

    arquivos_string = os.environ.get("NAUTILUS_SCRIPT_SELECTED_FILE_PATHS", "")
    lista_arquivos = arquivos_string.strip().split("\n")

    # 4. Processa cada arquivo selecionado
    for caminho in lista_arquivos:
        if not caminho.strip():
            continue

        if os.path.isfile(caminho):
            try:
                # Gera o nome de saída no formato: "nome_original-modificado.png"
                nome_base, _ = os.path.splitext(caminho)
                caminho_saida = f"{nome_base}-modificado.png"

                # 1º Passo: Lemos o original e removemos o fundo com rembg
                with open(caminho, "rb") as i:
                    input_data = i.read()

                output_data = remove(input_data, session=sessao_ia)

                # Gravamos o resultado do rembg diretamente no arquivo final
                with open(caminho_saida, "wb") as o:
                    o.write(output_data)

                # 2º Passo: Chamamos o ImageMagick para tratar as cores (Preto e Branco)
                subprocess.run(
                    [
                        "magick",
                        caminho_saida,
                        "-transparent",
                        "white",
                        "-trim",
                        "+repage",
                        "-modulate",
                        "0,0,100",
                        caminho_saida,
                    ],
                    check=True,
                    capture_output=True,
                    text=True,
                )

                sucessos += 1
            except subprocess.CalledProcessError as e:
                enviar_notificacao(f"Erro no ImageMagick: {e.stderr}")
            except FileNotFoundError:
                enviar_notificacao(
                    "Erro: O comando 'magick' não foi encontrado no sistema. Verifique a instalação."
                )
            except Exception as e:
                enviar_notificacao(
                    "Erro no Script", f"Falha ao processar: {os.path.basename(caminho)}"
                )


if __name__ == "__main__":
    enviar_notificacao("Cartorio", "Processamento iniciado...")
    main()
