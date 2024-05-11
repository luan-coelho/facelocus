### Variáveis de ambiente nessárias para funcionamento do container

* `AWS_ACCESS_KEY_ID` - Chave de acesso da AWS
* `AWS_SECRET_ACCESS_KEY` - Chave secreta de acesso da AWS
* `AWS_DEFAULT_REGION` - Região padrão da AWS

### Comando docker para criar container deste serviço

```bash
docker run --name facerecognition-service -d -e AWS_ACCESS_KEY_ID=<> -e AWS_SECRET_ACCESS_KEY=<> -e AWS_DEFAULT_REGION=sa-east-1 -e AWS_BUCKET_NAME=facelocus-prod -p 5000:5000 luancoelhobr/face-recognition-service:2.0
```