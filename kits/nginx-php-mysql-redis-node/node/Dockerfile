ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-bookworm

RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg \
    && npm install -g yarn

WORKDIR /var/www/app
