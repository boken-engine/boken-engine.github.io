FROM node:12.16.0

WORKDIR /app

COPY package.json /app/
COPY package-lock.json /app/

RUN npm install

COPY . /app/