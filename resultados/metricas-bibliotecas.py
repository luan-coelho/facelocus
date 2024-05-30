import matplotlib.pyplot as plt
import numpy as np

# Data for the libraries
libraries = ['Face Recognition', 'Deep Face', 'Insight Face']
accuracy = [1.0, 0.915, 0.83]
precision = [1.0, 1.0, 1.0]
recall = [1.0, 0.915, 0.83]
f_score = [2.0, 2.0, 2.0]
fallout = [0, 0, 0]
prediction_time = [4.0920, 0.9018, 0.2945]

# Plotting the metrics with values on bars
fig, ax = plt.subplots(2, 1, figsize=(12, 10))

# Metrics
x = np.arange(len(libraries))
width = 0.15

rects1 = ax[0].bar(x - 2 * width, accuracy, width, label='Acurácia')
rects2 = ax[0].bar(x - width, precision, width, label='Precisão')
rects3 = ax[0].bar(x, recall, width, label='Recall')
rects4 = ax[0].bar(x + width, f_score, width, label='F-score')
rects5 = ax[0].bar(x + 2 * width, fallout, width, label='Fallout')

ax[0].set_xlabel('Bibliotecas')
ax[0].set_ylabel('Valores')
ax[0].set_title('Comparação de Métricas')
ax[0].set_xticks(x)
ax[0].set_xticklabels(libraries)
ax[0].legend()


# Adding values on the bars
def add_values_on_bars(rects):
    for rect in rects:
        height = rect.get_height()
        ax[0].annotate(f'{height:.2f}',
                       xy=(rect.get_x() + rect.get_width() / 2, height),
                       xytext=(0, 3),  # 3 points vertical offset
                       textcoords="offset points",
                       ha='center', va='bottom')


add_values_on_bars(rects1)
add_values_on_bars(rects2)
add_values_on_bars(rects3)
add_values_on_bars(rects4)
add_values_on_bars(rects5)

# Prediction time
rects6 = ax[1].bar(libraries, prediction_time, color='orange')
ax[1].set_xlabel('Bibliotecas')
ax[1].set_ylabel('Tempo Médio de Predição (segundos)')
ax[1].set_title('Tempo Médio de Predição por Imagem')

# Adding values on the bars for prediction time
for rect in rects6:
    height = rect.get_height()
    ax[1].annotate(f'{height:.4f}',
                   xy=(rect.get_x() + rect.get_width() / 2, height),
                   xytext=(0, 3),  # 3 points vertical offset
                   textcoords="offset points",
                   ha='center', va='bottom')

fig.tight_layout()

plt.show()
