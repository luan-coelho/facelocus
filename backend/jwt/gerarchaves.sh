#Os comandos que você forneceu são comandos de terminal que usam a biblioteca OpenSSL para gerar e
#manipular chaves RSA para uso com JSON Web Tokens (JWTs). Aqui está uma explicação linha por linha
#do que cada comando está fazendo:

#mkdir jwt

#Este comando gera uma nova chave privada RSA de 2048 bits. A chave é escrita no arquivo
openssl genrsa -out rsaPrivateKey.pem 2048
#Este comando lê a chave privada RSA do arquivo privateKey.pem e gera a chave pública
#correspondente. A chave pública é escrita no arquivo publicKey.pem.
openssl rsa -pubout -in rsaPrivateKey.pem -out publicKey.pem
#Este comando converte a chave privada RSA do formato tradicional para o formato PKCS#8.
#A chave de entrada é lida do arquivo privateKey.pem e a chave convertida é
# escrita no arquivo privateKey.pem. A opção -nocrypt indica que a chave de saída não deve
# ser criptografada.
openssl pkcs8 -topk8 -nocrypt -inform pem -in rsaPrivateKey.pem -outform pem -out privateKey.pem
#Este comando altera as permissões do arquivo privateKey.pem para que somente o
#proprietário do arquivo possa ler e escrever nele. Este é um nível comum de permissão para
# chaves privadas, para evitar que outros usuários do sistema leiam a chave.
chmod 600 rsaPrivateKey.pem
chmod 600 privateKey.pem

#segue abaixo um exemplo de como trabalhar com refresh token
#https://chat.openai.com/share/1a908ffe-c46e-44ef-84f6-f15a20b27a82