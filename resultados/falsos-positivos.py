import matplotlib.pyplot as plt
import numpy as np

# Dados
labels = ['Face Recognition', 'Deep Face', 'Insight Face']
analyzed_images = 47
wrongly_recognized = np.array([
    [0, 0, 5],
    [6, 0, 0],
    [37, 39, 36]
])

# Configurações do gráfico
x = np.arange(len(labels))  # a localização das labels
width = 0.25  # a largura das barras

fig, ax = plt.subplots(figsize=(10, 6))

# Barras
rects1 = ax.bar(x - width, wrongly_recognized[:, 0], width, label='Foto 1')
rects2 = ax.bar(x, wrongly_recognized[:, 1], width, label='Foto 2')
rects3 = ax.bar(x + width, wrongly_recognized[:, 2], width, label='Foto 3')

# Adicionando texto às labels, título e configurando a legenda
ax.set_xlabel('Bibliotecas')
ax.set_ylabel('Quantidade de Imagens Reconhecidas Erradas')
ax.set_title('Falsos positivos por biblioteca')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

# Adicionando os valores acima das barras


def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


autolabel(rects1)
autolabel(rects2)
autolabel(rects3)

fig.tight_layout()

plt.show()
