import argparse

import numpy as np
from insightface.app import FaceAnalysis

from processamento import processar_biblioteca

app_face = FaceAnalysis()
app_face.prepare(ctx_id=0, det_size=(640, 640))


def comparar_faces(imagem_raiz, imagem_comparar):
    try:
        # img1 = cv2.imread(imagem_raiz)
        # img2 = cv2.imread(imagem_comparar)
        faces1 = app_face.get(imagem_raiz)
        faces2 = app_face.get(imagem_comparar)
        if len(faces1) == 0 or len(faces2) == 0:
            return False
        return np.dot(faces1[0].normed_embedding, faces2[0].normed_embedding.T)
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
