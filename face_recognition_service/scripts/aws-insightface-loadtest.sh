#!/bin/bash

endpoint="check-faces?face_photo=3/993e2182-dc68-4bed-8881-6b515bbda8f4/facephoto.jpg&profile_face_photo=3/facephoto.jpg"
url="http://18.230.249.227:5000/insightface/$endpoint"

for i in {1..15}
do
  echo "Response $i:"
  curl "$url" &
  echo ""  # Adiciona uma linha em branco para melhor visualização
done
wait  # Aguarda todas as chamadas em background terminarem