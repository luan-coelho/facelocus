import face_recognition
from deepface import DeepFace
from flask import Flask, request, jsonify

app = Flask(__name__)


# https://github.com/ageitgey/face_recognition
@app.route('/facerecognition/check-faces', methods=['GET'])
def fr_check_faces():
    # Verifica se o caminho das duas imagens foram enviadas
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')

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

    return jsonify({'faceDetected': face_detected}), 200


# https://github.com/serengil/deepface
@app.route('/deepface/check-faces', methods=['GET'])
def df_check_faces():
    # Verifica se o caminho das duas imagens foram enviadas
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')

    # Fazer a comparação facial
    result = DeepFace.verify(photo_face_path, profile_photo_face_path)
    face_detected = bool(result['verified'])

    # Verificar se as imagens são da mesma pessoa
    return jsonify({'faceDetected': face_detected}), 200


if __name__ == '__main__':
    app.run(debug=False)
