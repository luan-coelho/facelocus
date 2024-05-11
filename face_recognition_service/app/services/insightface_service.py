import os
import time

import cv2
import numpy as np
from insightface.app import FaceAnalysis

from app.models.face_detection_result import FaceDetectionResult
from app.services.s3_service import download_image, delete_local_file

# Inicializa o aplicativo de análise de face
app_face = FaceAnalysis()
app_face.prepare(ctx_id=0, det_size=(640, 640))


def check_face(photo_face_key, profile_photo_face_key) -> FaceDetectionResult:
    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), photo_face_key)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_photo_face_key)

    face_detection_result: FaceDetectionResult = execute_recognition(photo_face_path, profile_photo_face_path)

    # delete_local_file(photo_face_path)
    # delete_local_file(profile_photo_face_path)

    return face_detection_result


def compare_faces(image_path1, image_path2):
    img1 = cv2.imread(image_path1)
    img2 = cv2.imread(image_path2)

    faces1 = app_face.get(img1)
    faces2 = app_face.get(img2)

    if len(faces1) == 0 or len(faces2) == 0:
        return 0.0
        # abort(400, description='Não foi possível encontrar uma face em uma das imagens')

    # Calcula a similaridade do cosseno entre os embeddings das faces
    similarity = np.dot(faces1[0].normed_embedding, faces2[0].normed_embedding.T)
    return similarity


def execute_recognition(photo_face_path, profile_photo_face_path) -> FaceDetectionResult:
    start_time = time.time()

    similarity_score = compare_faces(photo_face_path, profile_photo_face_path)

    face_detected = True if similarity_score >= 0.6 else False

    end_time = time.time()
    execution_time = round(end_time - start_time, 3)

    return FaceDetectionResult(face_detected, execution_time)
