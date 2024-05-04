import os

import boto3
from botocore.exceptions import NoCredentialsError


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
