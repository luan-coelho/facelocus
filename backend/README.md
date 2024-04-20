```shell
sudo pacman -Syu base-devel cmake
```

```shell
sudo pacman -S python-pip
```

```shell
pip install --upgrade pip setuptools wheel --break-system-packages
```

```shell
pip install dlib --break-system-packages
```

```shell
pip install face_recognition --break-system-packages
```

Python 3.11.6

caminho: 
```pip 24.0 from /usr/lib/python3.11/site-packages/pip (python 3.11)```

.env
```
_DEV_AWS_ACCESS_KEY_ID=AKIAXU3ZHYYEDEFAVVED
_DEV_AWS_SECRET_ACCESS_KEY=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
_DEV_FILES_USERS_FACEPHOTO_RESOURCES=facelocus/users
_DEV_FACE_RECOGNITION_SERVICE_URL=http://127.0.0.1:5000/facerecognition/check-faces
_DEV_FACERECOGNITION_LIB_PATH=/home/luan/.local/bin/face_recognition
_DEV_DEEP_FACE_SERVICE_URL=http://127.0.0.1:5000/deepface/check-faces
_DEV_INSIGHT_FACE_SERVICE_URL=http://127.0.0.1:5000/insightface/check-faces
_DEV_TZ=America/Sao_Paulo
_TEST_FILES_USERS_FACEPHOTO_RESOURCES=facelocus-test/users
_TEST_FACERECOGNITION_LIB_PATH=/home/luan/.local/bin/face_recognition
_TEST_FACE_RECOGNITION_SERVICE_URL=http://127.0.0.1:5000/facerecognition/check-faces
_TEST_DEEP_FACE_SERVICE_URL=http://127.0.0.1:5000/deepface/check-faces
_TEST_INSIGHT_FACE_SERVICE_URL=http://127.0.0.1:5000/insightface/check-faces
_TEST_TZ=America/Sao_Paulo
```
