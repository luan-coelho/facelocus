import time

from flask import Blueprint, request, jsonify

from app.services.facerecognition_service import check_face

facerecognition_bp = Blueprint('facerecognition', __name__, url_prefix='/facerecognition')


# https://github.com/ageitgey/face_recognition
@facerecognition_bp.route('/check-faces', methods=['GET'])
def check_faces():
    face_photo_key = request.args.get('face_photo')
    profile_face_photo_key = request.args.get('profile_face_photo')

    face_detection_result = check_face(face_photo_key, profile_face_photo_key)

    return jsonify(face_detection_result.to_dict()), 200
