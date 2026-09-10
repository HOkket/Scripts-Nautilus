#!/usr/bin/env python3
import os
import subprocess
from PIL import Image


def notify(title, message):
    subprocess.run(["notify-send", title, message], env=os.environ)


def get_selected_files():
    raw = os.environ.get("NAUTILUS_SCRIPT_SELECTED_FILE_PATHS", "")
    if not raw:
        raw = os.environ.get("NAUTILUS_SCRIPT_SELECTED_FILE_PATHS", "")
    files = [f for f in raw.splitlines() if f.strip()]
    if not files:
        notify("Erro", "Nenhum arquivo selecionado.")
        exit(1)
    return files


def resize_image(image_path):
    result = subprocess.run(
        [
            "zenity",
            "--entry",
            "--title=Redimensionar Imagem",
            "--text=Digite o tamanho (largura x altura):",
            "--entry-text=800x600",
        ],
        capture_output=True,
        text=True,
        env=os.environ,
    )

    if result.returncode != 0:
        return

    size = result.stdout.strip()

    if not size:
        notify("Erro", "Nenhum tamanho informado.")
        return

    try:
        width, height = map(int, size.lower().split("x"))
    except ValueError:
        notify("Erro", "Formato inválido. Use: largura x altura (ex: 800x600)")
        return

    img = Image.open(image_path)
    img = img.resize((width, height), Image.LANCZOS)

    base, ext = os.path.splitext(image_path)
    new_path = f"{base}_{width}x{height}{ext}"
    img.save(new_path)

    notify("Sucesso", f"Imagem salva em: {new_path}")


def main():
    try:
        selected_files = get_selected_files()
        for selected_file in selected_files:
            resize_image(selected_file)
    except Exception as e:
        notify("Erro", f"Ocorreu um erro: {str(e)}")


if __name__ == "__main__":
    main()
