from flask import Blueprint, request, jsonify
from deepface import DeepFace

df_bp = Blueprint('deepface', __name__, url_prefix='/deepface')


# https://github.com/serengil/deepface
@df_bp.route('/check-faces', methods=['GET'])
def df_check_faces():
    # Verifica se o caminho das duas imagens foram enviadas
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')

    # Fazer a comparação facial
    result = DeepFace.verify(photo_face_path, profile_photo_face_path)
    face_detected = bool(result['verified'])

    # Verificar se as imagens são da mesma pessoa
    return jsonify({'faceDetected': face_detected}), 200
