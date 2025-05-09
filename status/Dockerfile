# Etapa 1: build da imagem
FROM node:18-alpine

# Diretório da aplicação dentro do container
WORKDIR /app

# Copia os arquivos de dependência
COPY package*.json ./

# Instala as dependências
RUN npm install

# Copia o restante do código
COPY . .

# Expõe a porta
EXPOSE 3000

# Comando de inicialização
CMD [ "npm", "start" ]
