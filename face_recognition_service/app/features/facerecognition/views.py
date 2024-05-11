import os

from flask import Blueprint, request, jsonify

from app.models.face_detection_result import FaceDetectionResult
from app.services.facerecognition_service import execute_recognition as fr_execute_recognition
from app.services.s3_service import download_image, delete_local_file

facerecognition_bp = Blueprint('facerecognition', __name__, url_prefix='/facerecognition')


# https://github.com/ageitgey/face_recognition
@facerecognition_bp.route('/check-faces', methods=['GET'])
def check_faces():
    photo_face_key = request.args.get('face_photo')
    profile_photo_face_key = request.args.get('profile_face_photo')

    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), photo_face_key)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_photo_face_key)

    fr_result: FaceDetectionResult = fr_execute_recognition(photo_face_path, profile_photo_face_path)

    delete_local_file(photo_face_path)
    delete_local_file(profile_photo_face_path)

    return jsonify(fr_result.to_dict())
