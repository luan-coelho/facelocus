import os
import time

import face_recognition
import psutil


def carregar_imagem(caminho_arquivo):
    try:
        return face_recognition.load_image_file(caminho_arquivo)
    except Exception as e:
        print(f"Erro ao carregar a imagem {caminho_arquivo}: {e}")
        return None


def comparar_faces(imagem_raiz, imagem_comparar):
    try:
        codificacao_raiz = face_recognition.face_encodings(imagem_raiz)[0]
        codificacao_comparar = face_recognition.face_encodings(imagem_comparar)[0]
        resultados = face_recognition.compare_faces([codificacao_raiz], codificacao_comparar)
        return resultados[0]
    except Exception as e:
        print(f"Erro ao comparar as imagens: {e}")
        return False


def obter_tamanho_imagem(caminho_arquivo):
    try:
        return os.path.getsize(caminho_arquivo)
    except Exception as e:
        print(f"Erro ao obter o tamanho da imagem {caminho_arquivo}: {e}")
        return 0


def processar_diretorio(diretorio_base):
    tempos_comparacao = []  # Lista para armazenar os tempos de comparação
    tamanhos_imagens = []  # Lista para armazenar os tamanhos das imagens
    uso_cpu = []  # Lista para armazenar o uso de CPU
    uso_nucleos = []  # Lista para armazenar o uso de núcleos da CPU
    quantidade_fotos = 0

    for id_dir in os.listdir(diretorio_base):
        caminho_id = os.path.join(diretorio_base, id_dir)
        if os.path.isdir(caminho_id):
            caminho_imagem_raiz = os.path.join(caminho_id, "facephoto.jpg")
            if os.path.exists(caminho_imagem_raiz):
                imagem_raiz = carregar_imagem(caminho_imagem_raiz)
                if imagem_raiz is None:
                    continue
                for uuid_dir in os.listdir(caminho_id):
                    caminho_uuid = os.path.join(caminho_id, uuid_dir)
                    if os.path.isdir(caminho_uuid):
                        caminho_imagem_comparar = os.path.join(caminho_uuid, "facephoto.jpg")
                        if os.path.exists(caminho_imagem_comparar):
                            imagem_comparar = carregar_imagem(caminho_imagem_comparar)
                            if imagem_comparar is None:
                                continue

                            quantidade_fotos += 1

                            tamanho_imagem_comparar = obter_tamanho_imagem(caminho_imagem_comparar)
                            tamanho_imagem_em_kb = round(tamanho_imagem_comparar / 1024, 2)  # Converter para KB
                            tamanhos_imagens.append(tamanho_imagem_em_kb)
                            print(f"Tamanho da imagem: {tamanho_imagem_em_kb} KB")

                            process = psutil.Process(os.getpid())
                            cpu_usage_start = process.cpu_percent(interval=None)
                            cpu_cores_start = psutil.cpu_percent(interval=None, percpu=True)

                            tempo_inicio = time.time()  # Início da contagem do tempo
                            correspondencia = comparar_faces(imagem_raiz, imagem_comparar)
                            tempo_fim = time.time()  # Fim da contagem do tempo

                            cpu_usage_end = process.cpu_percent(interval=None)
                            cpu_cores_end = psutil.cpu_percent(interval=None, percpu=True)

                            uso_cpu.append(cpu_usage_end - cpu_usage_start)
                            uso_nucleos.append([end - start for start, end in zip(cpu_cores_start, cpu_cores_end)])

                            tempo_decorrido = tempo_fim - tempo_inicio  # Tempo decorrido

                            print("Tempo decorrido:" + str(tempo_decorrido))
                            print(
                                f"Comparando {caminho_imagem_raiz} com {caminho_imagem_comparar}: {'Match' if correspondencia else 'No match'}")
                            if correspondencia:
                                tempos_comparacao.append(tempo_decorrido)  # Armazenar tempo decorrido

    if tempos_comparacao:  # Se houver tempos armazenados
        tempo_medio = sum(tempos_comparacao) / len(tempos_comparacao)
        print("\n===============================================")
        print(f"Tempo médio para comparar cada imagem: {tempo_medio:.4f} segundos")
        print("===============================================")
        print(f"Quantidade de imagens analisadas: {quantidade_fotos}")
        print("===============================================")
        print(f"Quantidade de imagens reconhecidas com sucesso: {len(tempos_comparacao)}")
        print("===============================================")
    if tamanhos_imagens:  # Se houver tamanhos armazenados
        tamanho_medio = (sum(tamanhos_imagens) / len(tamanhos_imagens))
        print(f"Tamanho médio das imagens: {tamanho_medio:.2f} KB")
        print("===============================================")
        print(f"Array das imagens: \n{tamanhos_imagens}")
        print("===============================================")
    if uso_cpu:  # Se houver uso de CPU armazenado
        uso_cpu_medio = sum(uso_cpu) / len(uso_cpu) / psutil.cpu_count()
        print(f"Uso médio de CPU durante as comparações: {uso_cpu_medio:.2f} %")
        print("===============================================")
    if uso_nucleos:  # Se houver uso de núcleos armazenado
        uso_nucleos_medio = [sum(core) / len(core) for core in zip(*uso_nucleos)]
        print(f"Uso médio de cada núcleo da CPU durante as comparações: {uso_nucleos_medio}")
        print("===============================================")


# Caminho do diretório base
diretorio_casa = os.path.expanduser('~')
diretorio_base = os.path.join(diretorio_casa, 'Facelocus/s3-images-high')

processar_diretorio(diretorio_base)
