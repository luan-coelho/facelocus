from flask import Blueprint, request

dl_bp = Blueprint('dlib', __name__, url_prefix='/dlib')


@dl_bp.route('/check-faces', methods=['GET'])
def compare_images_endpoint():
    # Carregar os caminhos das imagens
    photo_face_path = request.args.get('photoFacePath')
    profile_photo_face_path = request.args.get('profilePhotoFacePath')
