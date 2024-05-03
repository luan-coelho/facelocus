import os

import boto3
import face_recognition
from botocore.exceptions import NoCredentialsError
from flask import Blueprint, request, jsonify

facerecognition_bp = Blueprint('facerecognition', __name__, url_prefix='/facerecognition')


# https://github.com/ageitgey/face_recognition
@facerecognition_bp.route('/check-faces', methods=['GET'])
def check_faces():
    # Verifica se o caminho das duas imagens foram enviadas
    face_photo = request.args.get('face_photo')
    profile_face_photo = request.args.get('profile_face_photo')

    photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), face_photo)
    profile_photo_face_path = download_image(os.environ.get('AWS_BUCKET_NAME', 'facelocus'), profile_face_photo)

    if photo_face_path is None or profile_photo_face_path is None:
        return jsonify({'error': 'Dois caminhos devem ser enviados'}), 400

    # Carrega as fotos e obtém codificações faciais
    photo_face = face_recognition.load_image_file(photo_face_path)
    profile_photo = face_recognition.load_image_file(profile_photo_face_path)
    encoding1 = face_recognition.face_encodings(photo_face)
    encoding2 = face_recognition.face_encodings(profile_photo)

    # Validações
    if len(encoding1) == 0:
        return jsonify({'error': 'A foto do caminho {} não possui nenhum rosto'.format(photo_face_path)})

    if len(encoding2) == 0:
        return jsonify({'error': 'A foto do caminho {} não possui nenhum rosto'.format(profile_photo_face_path)})

    # Garante que cada imagem tenha exatamente um rosto
    if len(encoding1) > 1 or len(encoding2) > 1:
        return jsonify({'error': 'Cada foto deve conter apenas um rosto'}), 400

    # Compara as codificações faciais das duas imagens
    result = face_recognition.compare_faces(encoding1, encoding2[0])
    face_detected = True if result[0] else False

    # Deleta as imagens
    delete_local_file(photo_face_path)
    delete_local_file(profile_photo_face_path)

    return jsonify({'faceDetected': face_detected}), 200


def download_image(bucket_name, file_key):
    try:
        s3 = boto3.client('s3')
        download_path = '/tmp'  # Usando o diretório temporário comum em sistemas Unix
        file_path = os.path.join(download_path, file_key)
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        s3.download_file(bucket_name, file_key, file_path)
        return file_path
    except NoCredentialsError:
        return "Erro de credenciais da AWS", 403
    except Exception as e:
        return str(e), 500


def delete_local_file(file_path):
    """Remove o arquivo do sistema de arquivos local."""
    if os.path.exists(file_path):
        os.remove(file_path)
    else:
        print("Erro: O arquivo não existe e não pode ser deletado.")
