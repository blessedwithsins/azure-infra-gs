FROM node:12

WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./

RUN rm -rf node_modules/
RUN npm install
RUN npm install applicationinsights --save
RUN npm i --save lodash
RUN npm i --save lodash.isequal

ENV NODE_ENV=production

COPY scenarios ./scenarios
COPY testData ./testData
COPY utils ./utils

COPY config.js .


CMD ["npm", "test"]