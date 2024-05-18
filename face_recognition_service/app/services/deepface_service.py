import os
import time

from deepface import DeepFace

from app.models.face_detection_result import FaceDetectionResult
from app.services.s3_service import download_image, delete_local_file
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix

def check_face(photo_face_key, profile_photo_face_key) -> FaceDetectionResult:
    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), photo_face_key)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_photo_face_key)

    face_detected: FaceDetectionResult = execute_recognition(photo_face_path, profile_photo_face_path)

    delete_local_file(photo_face_path)
    delete_local_file(profile_photo_face_path)

    return face_detected


def execute_recognition(photo_face_path, profile_photo_face_path) -> FaceDetectionResult:
    start_time = time.time()

    result = DeepFace.verify(photo_face_path, profile_photo_face_path, enforce_detection=False)
    face_detected = result['verified']

    end_time = time.time()
    execution_time = round(end_time - start_time, 3)

    return FaceDetectionResult(face_detected, execution_time)


def calculate_metrics(true_labels, predicted_labels):
    accuracy = accuracy_score(true_labels, predicted_labels)
    precision = precision_score(true_labels, predicted_labels, average='weighted')
    recall = recall_score(true_labels, predicted_labels, average='weighted')
    f1 = f1_score(true_labels, predicted_labels, average='weighted')

    tn, fp, fn, tp = confusion_matrix(true_labels, predicted_labels).ravel()
    fallout = fp / (fp + tn)

    return {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1_score': f1,
        'fallout': fallout
    }
