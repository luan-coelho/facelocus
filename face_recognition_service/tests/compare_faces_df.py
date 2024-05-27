import argparse

from deepface import DeepFace

from processamento import processar_biblioteca


def comparar_faces(imagem_raiz, imagem_comparar):
    try:
        result = DeepFace.verify(imagem_raiz, imagem_comparar, enforce_detection=False)
        return result['verified']
    except Exception as e:
        print(f"Erro ao comparar as imagens: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Testes de reconhecimento para biblioteca Deepface")
    parser.add_argument("--qualidade", type=str, help="Qualidade - low | high", default='low')
    args = parser.parse_args()
    processar_biblioteca(comparar_faces, args.qualidade)


if __name__ == "__main__":
    main()
