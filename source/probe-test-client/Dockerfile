FROM node:12

WORKDIR /usr/src/app
COPY package.json ./
COPY package-lock.json ./

RUN rm -rf node_modules/
RUN npm install && npm install applicationinsights --save && npm i --save lodash && npm i --save lodash.isequal

ENV NODE_ENV=production

COPY scenarios ./scenarios
COPY testData ./testData
COPY utils ./utils

COPY config.js .

CMD ["npm", "test"]