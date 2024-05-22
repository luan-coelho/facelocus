import os
import face_recognition


def load_image(file_path):
    try:
        return face_recognition.load_image_file(file_path)
    except Exception as e:
        print(f"Erro ao carregar a imagem {file_path}: {e}")
        return None


def compare_faces(root_image, compare_image):
    try:
        root_encoding = face_recognition.face_encodings(root_image)[0]
        compare_encoding = face_recognition.face_encodings(compare_image)[0]
        results = face_recognition.compare_faces([root_encoding], compare_encoding)
        return results[0]
    except Exception as e:
        print(f"Erro ao comparar as imagens: {e}")
        return False


def process_directory(base_dir):
    for id_dir in os.listdir(base_dir):
        id_path = os.path.join(base_dir, id_dir)
        if os.path.isdir(id_path):
            root_image_path = os.path.join(id_path, "facephoto.jpg")
            if os.path.exists(root_image_path):
                root_image = load_image(root_image_path)
                if root_image is None:
                    continue
                for uuid_dir in os.listdir(id_path):
                    uuid_path = os.path.join(id_path, uuid_dir)
                    if os.path.isdir(uuid_path):
                        compare_image_path = os.path.join(uuid_path, "facephoto.jpg")
                        if os.path.exists(compare_image_path):
                            compare_image = load_image(compare_image_path)
                            if compare_image is None:
                                continue
                            match = compare_faces(root_image, compare_image)
                            print(
                                f"Comparando {root_image_path} com {compare_image_path}: {'Match' if match else 'No match'}")


# Caminho do diretório base
home_dir = os.path.expanduser('~')
base_dir = os.path.join(home_dir, 'Facelocus/s3-images')

process_directory(base_dir)
