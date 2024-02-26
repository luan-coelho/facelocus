import cv2
import numpy as np
from flask import Blueprint, request
from flask import jsonify
from insightface.app import FaceAnalysis

insightface_bp = Blueprint('insightface', __name__, url_prefix='/insightface')

# Inicializa o aplicativo de análise de face
app_face = FaceAnalysis()
app_face.prepare(ctx_id=0, det_size=(640, 640))


# https://github.com/deepinsight/insightface
@insightface_bp.route('/check-faces', methods=['GET'])
def compare_images_endpoint():
    # Carregar os caminhos das imagens
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')

    similarity_score = compare_faces(photo_face_path, profile_photo_face_path)
    face_detected = True if similarity_score >= 0.6 else False

    return jsonify({'faceDetected': face_detected}), 200


def compare_faces(image_path1, image_path2):
    img1 = cv2.imread(image_path1)
    img2 = cv2.imread(image_path2)

    faces1 = app_face.get(img1)
    faces2 = app_face.get(img2)

    if len(faces1) == 0 or len(faces2) == 0:
        return None, "Não foi possível encontrar uma face em uma das imagens."

        # Calcula a similaridade do cosseno entre os embeddings das faces
    similarity = np.dot(faces1[0].normed_embedding, faces2[0].normed_embedding.T)
    return similarity
