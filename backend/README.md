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
_DEV_FILES_USERS_FACEPHOTO_RESOURCES=facelocus/users
_TEST_FILES_USERS_FACEPHOTO_RESOURCES=facelocus-test/users
_DEV_FACERECOGNITION_LIB_PATH=/home/luan/.local/bin/face_recognition
_TEST_FACERECOGNITION_LIB_PATH=/home/luan/.local/bin/face_recognition
TZ=America/Sao_Paulo
```
