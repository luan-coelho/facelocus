import os
import time

from deepface import DeepFace

from app.models.face_detection_result import FaceDetectionResult
from app.services.s3_service import download_image, delete_local_file


def check_face(photo_face_key, profile_photo_face_key) -> FaceDetectionResult:
    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), photo_face_key)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_photo_face_key)

    face_detected: FaceDetectionResult = execute_recognition(photo_face_path, profile_photo_face_path)

    # delete_local_file(photo_face_path)
    # delete_local_file(profile_photo_face_path)

    return face_detected


def execute_recognition(photo_face_path, profile_photo_face_path) -> FaceDetectionResult:
    start_time = time.time()

    result = DeepFace.verify(photo_face_path, profile_photo_face_path, enforce_detection=False)
    face_detected = result['verified']

    end_time = time.time()
    execution_time = round(end_time - start_time, 3)

    return FaceDetectionResult(face_detected, execution_time)
