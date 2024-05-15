import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Dados de exemplo
data = {
    'Biblioteca': ['DeepFace', 'Face Recognition', 'InsigthFace'],
    'Acurácia': [0.95, 0.92, 0.90],
    'Precisão': [0.94, 0.91, 0.89],
    'Recall': [0.93, 0.90, 0.88],
    'F-score': [0.935, 0.905, 0.885],
    'Fallout': [0.05, 0.08, 0.10],
    'Tempo Predição': [0.1, 0.15, 0.12]
}

df = pd.DataFrame(data)

# Gráficos de Barras para Acurácia, Precisão, Recall, F-score e Fallout
metrics = ['Acurácia', 'Precisão', 'Recall', 'F-score', 'Fallout']

for metric in metrics:
    plt.figure(figsize=(10, 6))
    sns.barplot(x='Biblioteca', y=metric, data=df)
    plt.title(f'Comparação de {metric}')
    plt.show()

# Gráfico de Linhas para Tempo de Predição
plt.figure(figsize=(10, 6))
sns.lineplot(x='Biblioteca', y='Tempo Predição', data=df, marker='o')
plt.title('Tempo de Predição')
plt.show()
