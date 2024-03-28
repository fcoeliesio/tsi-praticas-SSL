#!/bin/bash

# Criando o arquivo docker-compose.yml com os volumes já mapeados nele 
cat << 'EOF' > docker-compose.yml
version: '3'
services:
  web:
    image: httpd:latest
    container_name: meu-container
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./server.crt:/usr/local/apache2/conf/server.crt
      - ./server.key:/usr/local/apache2/conf/server.key
EOF

# Gerando os certificados SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt

# Criando o contêiner docker
sudo docker compose up -d
sudo docker ps

# Configurando os arquivos do servidor
sudo docker exec -it meu-container bash -c "cat conf/httpd.conf | grep ssl.conf"
sudo docker exec -it meu-container bash -c "cat conf/httpd.conf | grep mod_ssl"
sudo docker exec -it meu-container bash -c "cat conf/httpd.conf | grep mod_socache_shmcb"

# Substituição de texto usando SED e retirando # para tornar a linha de código ativa
sudo docker exec -it meu-container bash -c "sed -i -e 's/^#\(Include.*httpd-ssl.conf\)/\1/' -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' conf/httpd.conf"

# Passo 6: Reiniciando o contêiner
sudo docker compose restart