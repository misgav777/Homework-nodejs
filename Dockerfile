FROM node:lts-alpine3.18

WORKDIR /app

COPY package*.json ./

RUN npm install \
    && npm cache clean --force

COPY . .

EXPOSE 3000

CMD ["npm", "start"]