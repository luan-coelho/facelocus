from deepface import DeepFace

from tests.processamento import processar_biblioteca


def comparar_faces(imagem_raiz, imagem_comparar):
    try:
        result = DeepFace.verify(imagem_raiz, imagem_comparar, enforce_detection=False)
        return result['verified']
    except Exception as e:
        print(f"Erro ao comparar as imagens: {e}")
        return False


processar_biblioteca(comparar_faces)
