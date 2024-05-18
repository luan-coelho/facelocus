from flask import Blueprint, request, jsonify

from app.services.deepface_service import check_face, calculate_metrics

deepface_bp = Blueprint('deepface', __name__, url_prefix='/deepface')


# https://github.com/serengil/deepface
@deepface_bp.route('/check-faces', methods=['GET'])
def check_faces():
    photo_face_key = request.args.get('face_photo')
    profile_photo_face_key = request.args.get('profile_face_photo')

    face_detection_result = check_face(photo_face_key, profile_photo_face_key)

    # Exemplo de cálculo de métricas
    # Dados fictícios de exemplo
    true_labels = [1, 0, 1, 1, 0, 1, 0, 0, 1, 0]  # Rótulos verdadeiros
    predicted_labels = [1, 0, 1, 0, 0, 1, 0, 0, 1, 1]  # Rótulos previstos pelo serviço

    metrics = calculate_metrics(true_labels, predicted_labels)

    return jsonify(face_detection_result.to_dict()), 200
