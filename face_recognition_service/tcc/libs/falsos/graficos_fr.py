import matplotlib.pyplot as plt
import numpy as np

# Dados fornecidos
data_baixa = {
    "memoria_ram": [2.9, 3.7],
    "tempo_medio": 1.6153,
    "imagens_analisadas": 127,
    "imagens_reconhecidas": 30,
    "uso_cpu": 8.35,
    "uso_nucleo_cpu": [2.4, 11.55, -0.55, -1.02, -0.69, 17.35, 2.41, 16.04, 0.42, -0.66, 0.38, 33.85]
}

data_alta = {
    "memoria_ram": [2.9, 4.0],
    "tempo_medio": 4.0549,
    "imagens_analisadas": 47,
    "imagens_reconhecidas": 47,
    "uso_cpu": 8.32,
    "uso_nucleo_cpu": [-0.60, 0.39, 0.68, -0.58, -0.27, 0.34, 0.56, 1.56, -0.87, -0.98, -0.04, 7.11]
}

# Criando uma figura e uma grade com 3 linhas e 2 colunas
fig = plt.figure(figsize=(15, 15))
fig.suptitle('Biblioteca Face Recognition', fontsize=18, fontweight='bold')
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
