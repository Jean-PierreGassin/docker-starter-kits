ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        bash-completion \
        zsh \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg \
    && npm install -g yarn

RUN printf '%s\n' \
    'autoload -Uz compinit' \
    'compinit' \
    > /etc/zsh/zshrc

WORKDIR /var/www/app