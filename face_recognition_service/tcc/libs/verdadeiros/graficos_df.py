import matplotlib.pyplot as plt
import numpy as np

# Dados fornecidos
data_baixa = {
    "memoria_ram": [2.9, 4.0],
    "tempo_medio": 0.4006,
    "imagens_analisadas": 127,
    "imagens_reconhecidas": 32,
    "uso_cpu": 59.86,
    "uso_nucleo_cpu": [60.86299212598424, 59.2543307086614, 57.54645669291337, 56.31653543307087, 56.788188976377924, 59.42519685039366, 60.56456692913387, 61.70944881889763, 58.535433070866134, 59.55511811023622, 59.76929133858269, 60.04803149606298]
}

data_alta = {
    "memoria_ram": [2.9, 5.3],
    "tempo_medio": 0.9018,
    "imagens_analisadas": 47,
    "imagens_reconhecidas": 43,
    "uso_cpu": 66.18,
    "uso_nucleo_cpu": [60.48510638297872, 32.251063829787235, 62.81063829787234, 61.33191489361702, 62.34468085106381, 43.12127659574469, 64.78297872340426, 53.60638297872342, 65.35106382978725, 64.15531914893616, 63.25744680851066, 61.55957446808512]
}

# Criando uma figura e uma grade com 3 linhas e 2 colunas
fig = plt.figure(figsize=(15, 15))
fig.suptitle('Biblioteca Deep Face', fontsize=18, fontweight='bold')
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
