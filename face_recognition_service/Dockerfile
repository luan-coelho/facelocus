# Usa a imagem base do Python com Debian Buster para compatibilidade
FROM python:3.10-slim-buster

# Instala as dependências necessárias para compilar o dlib
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    build-essential \
    cmake \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libopenblas-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho no container
WORKDIR /app

# Copia os arquivos da aplicação para o diretório de trabalho
COPY . /app

RUN apt-get update && apt-get install -y python3-opencv
RUN apt-get install libgl1
RUN pip install opencv-python
RUN pip install opencv-contrib-python
# Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Expõe a porta 5000
EXPOSE 5000

# Comando para iniciar a aplicação Flask
CMD ["flask", "run", "--host=0.0.0.0"]
