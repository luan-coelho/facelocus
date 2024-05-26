import matplotlib.pyplot as plt
import pandas as pd

# Dados fornecidos
data = {
    "Qualidade": ["Alta", "Baixa"],
    "Quantidade de imagens analisadas": [47, 127],
    "Tempo médio para comparar cada imagem (s)": [4.0571, 1.6155],
    "Quantidade de imagens reconhecidas com sucesso": [47, 30],
    "Tamanho médio das imagens (KB)": [915.00, 38.26]
}

# Criação do DataFrame
df = pd.DataFrame(data)

# Configurações dos gráficos com valores nas barras
fig, axs = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle('Comparação de Desempenho entre Imagens de Alta e Baixa Qualidade', fontsize=16)

# Função para adicionar valores nas barras
def add_values(ax, data):
    for i, v in enumerate(data):
        ax.text(i, v + 0, str(v), ha='center', va='bottom')

# Gráfico 1: Quantidade de imagens analisadas
axs[0, 0].bar(df["Qualidade"], df["Quantidade de imagens analisadas"], color=['blue', 'orange'])
add_values(axs[0, 0], df["Quantidade de imagens analisadas"])
axs[0, 0].set_title('Quantidade de Imagens Analisadas')
axs[0, 0].set_xlabel('Qualidade')
axs[0, 0].set_ylabel('Quantidade de Imagens')

# Gráfico 2: Tempo médio para comparar cada imagem
axs[0, 1].bar(df["Qualidade"], df["Tempo médio para comparar cada imagem (s)"], color=['blue', 'orange'])
add_values(axs[0, 1], df["Tempo médio para comparar cada imagem (s)"])
axs[0, 1].set_title('Tempo Médio para Comparar Cada Imagem')
axs[0, 1].set_xlabel('Qualidade')
axs[0, 1].set_ylabel('Tempo Médio (s)')

# Gráfico 3: Quantidade de imagens reconhecidas com sucesso
axs[1, 0].bar(df["Qualidade"], df["Quantidade de imagens reconhecidas com sucesso"], color=['blue', 'orange'])
add_values(axs[1, 0], df["Quantidade de imagens reconhecidas com sucesso"])
axs[1, 0].set_title('Quantidade de Imagens Reconhecidas com Sucesso')
axs[1, 0].set_xlabel('Qualidade')
axs[1, 0].set_ylabel('Quantidade de Imagens')

# Gráfico 4: Tamanho médio das imagens
axs[1, 1].bar(df["Qualidade"], df["Tamanho médio das imagens (KB)"], color=['blue', 'orange'])
add_values(axs[1, 1], df["Tamanho médio das imagens (KB)"])
axs[1, 1].set_title('Tamanho Médio das Imagens')
axs[1, 1].set_xlabel('Qualidade')
axs[1, 1].set_ylabel('Tamanho Médio (KB)')

# Ajustar layout
plt.tight_layout(rect=[0, 0, 1, 0.96])

# Exibir os gráficos
plt.show()
