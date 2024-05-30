import matplotlib.pyplot as plt

# Lista de valores arredondados para alta resolução
valores_alta_resolucao = [349.91, 398.09, 1177.17, 1835.09, 1404.21, 1251.85, 470.24, 465.2, 515.92, 455.92, 470.51, 496.68, 1633.88,
           1396.48, 1370.22, 423.51, 1471.98, 353.66, 1354.33, 1214.45, 1108.1, 1348.37, 1078.72, 540.82, 606.86,
           597.16, 607.16, 587.79, 320.82, 505.65, 1478.68, 1554.05, 1493.8, 713.41, 1476.78, 420.75, 637.98, 383.25,
           666.68, 376.97, 338.73, 1326.94, 1211.62, 1154.92, 1262.95, 1302.59, 1394.07]

# Lista de valores arredondados para baixa resolução
valores_baixa_resolucao = [39.69, 51.75, 48.56, 46.54, 46.45, 45.7, 43.32, 48.12, 40.37, 40.35, 50.82, 50.82, 55.22, 50.46, 50.5, 48.36,
           50.27, 46.56, 51.66, 32.46, 32.69, 36.47, 42.12, 27.42, 37.71, 43.48, 39.8, 36.76, 32.05, 23.55, 23.41,
           32.38, 29.8, 54.1, 45.3, 41.7, 36.69, 52.73, 38.46, 41.46, 40.22, 36.64, 40.2, 42.75, 52.1, 51.55, 39.88,
           45.4, 42.6, 41.9, 38.62, 39.24, 38.61, 42.61, 49.52, 40.77, 43.99, 41.1, 41.0, 48.11, 46.83, 21.91, 38.03,
           28.24, 34.33, 39.79, 32.61, 31.78, 29.54, 30.31, 35.08, 27.22, 34.16, 34.52, 43.06, 40.55, 32.79, 38.69,
           33.18, 28.94, 34.75, 38.79, 39.6, 33.54, 33.5, 30.72, 41.27, 38.3, 63.31, 33.08, 36.63, 30.33, 29.96, 32.09,
           31.64, 31.25, 32.5, 30.74, 34.94, 36.66, 35.34, 38.02, 37.34, 31.81, 33.64, 30.88, 35.74, 33.18, 33.01,
           37.44, 38.11, 35.43, 35.22, 36.31, 33.22, 36.96, 56.79, 35.3, 40.39, 24.76, 24.76, 32.05, 28.6, 27.55, 26.9,
           26.04, 36.64]

# Criar gráficos de barras
fig, axs = plt.subplots(2, 1, figsize=(10, 8))

# Gráfico de barras para alta resolução
axs[0].bar(range(len(valores_alta_resolucao)), valores_alta_resolucao, color='green')
axs[0].set_xlabel('Índice da Imagem')
axs[0].set_ylabel('Tamanho da Imagem em KB')
axs[0].set_title('Imagens com Alta Resolução')

# Gráfico de barras para baixa resolução
axs[1].bar(range(len(valores_baixa_resolucao)), valores_baixa_resolucao, color='purple')
axs[1].set_xlabel('Índice da Imagem')
axs[1].set_ylabel('Tamanho da Imagem em KB')
axs[1].set_title('Imagens com Baixa Resolução')

plt.tight_layout()
plt.show()
