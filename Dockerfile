FROM node:16.14.2 as base
ENV APP_HOME=/usr/src/app \
  TERM=xterm
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

FROM base as development
ENV NODE_ENV development
COPY package.json package-lock.json ./
RUN npm install
RUN npm rebuild node-sass
COPY config ./config
CMD ["npm", "start"]

FROM development as build
ENV NODE_ENV production
RUN npm run build

FROM base as production
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm install --production
RUN npm rebuild node-sass
COPY --from=build $APP_HOME/dist ./dist
CMD ["npm", "run", "start:prod"]
