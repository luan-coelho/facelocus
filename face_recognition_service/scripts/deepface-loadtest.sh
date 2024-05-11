#!/bin/bash

url="http://localhost:5000/deepface/check-faces?face_photo=1/1ce669d6-d73c-4f68-8ebf-16e506559510/facephoto.jpg&profile_face_photo=1/facephoto.jpg"

for i in {1..15}
do
  echo "Response $i:"
  curl "$url" &
  echo ""  # Adiciona uma linha em branco para melhor visualização
done
wait  # Aguarda todas as chamadas em background terminarem