FROM node:12

WORKDIR /usr/src/app
COPY package.json ./

RUN npm install

ENV NODE_ENV=production

COPY cronjob.js ./cronjob.js
COPY config.js ./config.js

CMD ["node", "cronjob.js"]
