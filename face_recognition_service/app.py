import face_recognition
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/check-faces', methods=['GET'])
def compare_photos():
    # Verifica se duas imagens foram enviadas
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')

    if photo_face_path is None or profile_photo_face_path is None:
        return jsonify({'error': 'Two paths must be sent.'}), 400

    # Carrega as fotos e obtém codificações faciais
    image1 = face_recognition.load_image_file(photo_face_path)
    image2 = face_recognition.load_image_file(profile_photo_face_path)
    encoding1 = face_recognition.face_encodings(image1)
    encoding2 = face_recognition.face_encodings(image2)

    # Garante que cada imagem tenha exatamente um rosto
    if len(encoding1) != 1 or len(encoding2) != 1:
        return jsonify({'error': 'Cada foto deve conter um e apenas um rosto'}), 400

    # Compara as codificações faciais das duas imagens
    results = face_recognition.compare_faces(encoding1, encoding2[0])

    if results[0]:
        return jsonify({'faceDetected': True})
    else:
        return jsonify({'faceDetected': False})


if __name__ == '__main__':
    app.run(debug=False)
