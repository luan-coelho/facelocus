import face_recognition

from tests.processamento import processar_biblioteca


def comparar_faces(imagem_raiz, imagem_comparar):
    try:
        codificacao_raiz = face_recognition.face_encodings(imagem_raiz)[0]
        codificacao_comparar = face_recognition.face_encodings(imagem_comparar)[0]
        resultados = face_recognition.compare_faces([codificacao_raiz], codificacao_comparar)
        return resultados[0]
    except Exception as e:
        print(f"Erro ao comparar as imagens: {e}")
        return False


processar_biblioteca(comparar_faces)
