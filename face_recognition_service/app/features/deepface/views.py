from flask import Blueprint, request, jsonify

from app.services.deepface_service import check_face

deepface_bp = Blueprint('deepface', __name__, url_prefix='/deepface')


# https://github.com/serengil/deepface
@deepface_bp.route('/check-faces', methods=['GET'])
def check_faces():
    photo_face_key = request.args.get('face_photo')
    profile_photo_face_key = request.args.get('profile_face_photo')

    face_detection_result = check_face(photo_face_key, profile_photo_face_key)

    return jsonify(face_detection_result.to_dict()), 200
