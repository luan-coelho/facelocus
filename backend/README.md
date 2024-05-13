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

Rodar postgres de desenvolvimento no docker

```shell
docker run --name facelocus-dbdev -e POSTGRES_PASSWORD=root -e POSTGRES_DB=facelocus-dev -p 5432:5432 -d postgres
```

Rodar postgres de testes no docker

```shell
docker run --name facelocus-dbtest -e POSTGRES_PASSWORD=root -e POSTGRES_DB=facelocus-test -p 5433:5432 -d postgres
```

Criar extensão unaccent no banco de dados, reponsável por remover acentos

```postgresql
CREATE EXTENSION unaccent;
```

Comando para gerar o .jar da aplicação

```shell
./gradlew build -Dquarkus.package.type=uber-jar -x test
```

Executar jar

```shell
nohup java -Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -Duser.timezone=America/Sao_Paulo -jar facelocus-1.0-runner.jar &
```