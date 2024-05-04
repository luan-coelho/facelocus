from flask import Blueprint, request
from flask import jsonify

from app.services.insightface_service import check_face

insightface_bp = Blueprint('insightface', __name__, url_prefix='/insightface')


# https://github.com/deepinsight/insightface
@insightface_bp.route('/check-faces', methods=['GET'])
def check_faces():
    face_photo_key = request.args.get('face_photo')
    profile_face_photo_key = request.args.get('profile_face_photo')

    face_detection_result = check_face(face_photo_key, profile_face_photo_key)

    return jsonify(face_detection_result.to_dict()), 200
