FROM node:12

WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./

RUN npm install

ENV NODE_ENV=production

COPY scenarios ./scenarios
COPY test_data ./test_data
COPY utils ./utils

COPY config.js .


CMD ["npm", "test"]
