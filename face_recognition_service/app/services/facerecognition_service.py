import os
import time

import face_recognition

from app.models.face_detection_result import FaceDetectionResult
from app.services.s3_service import download_image, delete_local_file


def check_face(photo_face_key, profile_photo_face_key) -> FaceDetectionResult:
    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), photo_face_key)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_photo_face_key)

    face_detection_result: FaceDetectionResult = execute_recognition(photo_face_path, profile_photo_face_path)

    delete_local_file(photo_face_key)
    delete_local_file(profile_photo_face_key)

    return face_detection_result


def execute_recognition(photo_face_path, profile_photo_face_path) -> FaceDetectionResult:
    start_time = time.time()

    photo_face = face_recognition.load_image_file(photo_face_path)
    profile_photo = face_recognition.load_image_file(profile_photo_face_path)
    encoding1 = face_recognition.face_encodings(photo_face)
    encoding2 = face_recognition.face_encodings(profile_photo)
    result = face_recognition.compare_faces(encoding1, encoding2[0])

    face_detected = True if result[0] else False
    end_time = time.time()
    execution_time = round(end_time - start_time, 3)

    return FaceDetectionResult(face_detected, execution_time)
