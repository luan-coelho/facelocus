import matplotlib.pyplot as plt
import seaborn as sns

# Lista de valores arredondados
valores = [349.91, 398.09, 1177.17, 1835.09, 1404.21, 1251.85, 470.24, 465.2, 515.92, 455.92, 470.51, 496.68, 1633.88,
           1396.48, 1370.22, 423.51, 1471.98, 353.66, 1354.33, 1214.45, 1108.1, 1348.37, 1078.72, 540.82, 606.86,
           597.16, 607.16, 587.79, 320.82, 505.65, 1478.68, 1554.05, 1493.8, 713.41, 1476.78, 420.75, 637.98, 383.25,
           666.68, 376.97, 338.73, 1326.94, 1211.62, 1154.92, 1262.95, 1302.59, 1394.07]

# Configurar a paleta de cores do seaborn
# sns.set_palette("darkgreen")

# Criar gráfico de barras
plt.figure(figsize=(15, 7))
plt.bar(range(len(valores)), valores, color='green')
plt.xlabel('Índice da Imagem')
plt.ylabel('Tamanho da Imagem em KB')
plt.title('Tamanho das Imagens Coletadas com Alta Resolução')
plt.show()
