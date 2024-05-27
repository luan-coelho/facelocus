import matplotlib.pyplot as plt
import numpy as np

# Dados fornecidos
data_baixa = {
    "memoria_ram": [2.9, 4.1],
    "tempo_medio": 0.2471,
    "imagens_analisadas": 127,
    "imagens_reconhecidas": 30,
    "uso_cpu": 72.30,
    "uso_nucleo_cpu": [67.29370078740156, 71.70157480314963, 67.44173228346457, 66.66220472440945, 65.63700787401578, 65.22283464566931, 23.42283464566928, 62.90314960629922, 68.95275590551181, 64.40708661417322, 71.4716535433071, 64.50787401574804]
}

data_alta = {
    "memoria_ram": [2.9, 4.2],
    "tempo_medio": 0.2945,
    "imagens_analisadas": 47,
    "imagens_reconhecidas": 39,
    "uso_cpu": 68.07,
    "uso_nucleo_cpu": [-0.2212765957446806, 17.957446808510646, 45.45531914893617, 45.12765957446808, 41.92765957446808, 31.763829787234044, 16.023404255319146, 60.25531914893618, 41.48085106382979, 43.94042553191489, 44.20212765957446, 51.714893617021275]
}

# Criando uma figura e uma grade com 3 linhas e 2 colunas
fig = plt.figure(figsize=(15, 15))
fig.suptitle('Biblioteca Insight Face', fontsize=18, fontweight='bold')
gs = fig.add_gridspec(3, 2, height_ratios=[1, 1, 1])

# Uso de Memória RAM
ax1 = fig.add_subplot(gs[0, 0])
ax1.plot(['Antes', 'Depois'], data_baixa['memoria_ram'], label='Baixa Qualidade', marker='o')
ax1.plot(['Antes', 'Depois'], data_alta['memoria_ram'], label='Alta Qualidade', marker='o')
for i, v in enumerate(data_baixa['memoria_ram']):
    ax1.text(i, v + 0.0, str(v), ha='center', va='bottom')
for i, v in enumerate(data_alta['memoria_ram']):
    ax1.text(i, v + 0.0, str(v), ha='center', va='bottom')
ax1.set_title('Uso de Memória RAM')
ax1.set_ylabel('RAM (Gi)')
ax1.grid(True)
ax1.legend()

# Tempo Médio de Comparação
ax2 = fig.add_subplot(gs[0, 1])
ax2.bar(['Baixa Qualidade', 'Alta Qualidade'], [data_baixa['tempo_medio'], data_alta['tempo_medio']], color=['#003C84', '#FDB705'])
for i, v in enumerate([data_baixa['tempo_medio'], data_alta['tempo_medio']]):
    ax2.text(i, v + 0.0, str(v), ha='center', va='bottom')
ax2.set_title('Tempo Médio para Comparar Cada Imagem')
ax2.set_ylabel('Tempo (s)')
ax2.grid(True)

# Quantidade de Imagens Analisadas e Reconhecidas
ax3 = fig.add_subplot(gs[1, 0])
width = 0.35
ind = np.arange(2)
barras1 = ax3.bar(ind - width/2, [data_baixa['imagens_analisadas'], data_alta['imagens_analisadas']], width, label='Analisadas', color='#003C84')
barras2 = ax3.bar(ind + width/2, [data_baixa['imagens_reconhecidas'], data_alta['imagens_reconhecidas']], width, label='Reconhecidas', color='#FDB705')
for barra in barras1:
    height = barra.get_height()
    ax3.text(barra.get_x() + barra.get_width()/2.0, height + 1, str(height), ha='center', va='bottom')
for barra in barras2:
    height = barra.get_height()
    ax3.text(barra.get_x() + barra.get_width()/2.0, height + 1, str(height), ha='center', va='bottom')
ax3.set_title('Quantidade de Imagens Analisadas e Reconhecidas')
ax3.set_ylabel('Quantidade')
ax3.set_xticks(ind)
ax3.set_xticklabels(['Baixa Qualidade', 'Alta Qualidade'])
ax3.legend()
ax3.grid(True)

# Uso Médio de CPU
ax4 = fig.add_subplot(gs[1, 1])
ax4.bar(['Baixa Qualidade', 'Alta Qualidade'], [data_baixa['uso_cpu'], data_alta['uso_cpu']], color=['#003C84', '#FDB705'])
for i, v in enumerate([data_baixa['uso_cpu'], data_alta['uso_cpu']]):
    ax4.text(i, v + 0.0, str(v), ha='center', va='bottom')
ax4.set_title('Uso Médio de CPU')
ax4.set_ylabel('Uso de CPU (%)')
ax4.grid(True)

# Uso Médio de Cada Núcleo da CPU
ax5 = fig.add_subplot(gs[2, :])
cores = range(1, 13)
ax5.plot(cores, data_baixa["uso_nucleo_cpu"], label='Baixa Qualidade', marker="o")
ax5.plot(cores, data_alta["uso_nucleo_cpu"], label='Alta Qualidade', marker="o")
ax5.set_ylabel('Uso de cada núcleo da CPU (%)')
ax5.set_xlabel('Núcleo da CPU')
ax5.set_title('Uso médio de cada núcleo da CPU durante as comparações')
ax5.legend()
ax5.grid(True)

# Ajustando o layout para que não haja sobreposição
plt.tight_layout()

# Mostrando o gráfico
plt.show()
