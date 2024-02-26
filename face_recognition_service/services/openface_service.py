import numpy as np


def load_embeddings(file_path):
    # Esta função depende de como os embeddings são salvos (por exemplo, em CSV)
    return np.loadtxt(file_path, delimiter=',')


def calculate_distance(embedding1, embedding2):
    return np.linalg.norm(embedding1 - embedding2)


# Carrega os embeddings
embedding1 = load_embeddings('caminho/para/embedding1.csv')
embedding2 = load_embeddings('caminho/para/embedding2.csv')

# Calcula a distância entre os dois embeddings
distance = calculate_distance(embedding1, embedding2)

print(f"Distância entre as faces: {distance}")

# Define um limiar para decidir se são a mesma pessoa
threshold = 0.6  # Ajuste conforme necessário
if distance < threshold:
    print("As faces são da mesma pessoa.")
else:
    print("As faces não são da mesma pessoa.")
