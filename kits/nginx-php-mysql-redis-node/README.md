# Nginx / PHP / MySQL / Redis / Node Starter Kit

Docker starter kit for PHP applications that need Nginx, MySQL, Redis, and a separate Node container for frontend tooling. The kit is designed to be copied into a project and configured through `.env` so multiple projects can run side by side.

## Includes

This kit provides:

- Nginx
- PHP-FPM with Composer and Xdebug
- MySQL
- Redis
- Node.js with Yarn
- MailHog

## Included Tooling

The relevant tooling is installed inside containers rather than expected on the host machine.

- `composer` in the `php` container
- `node` and `yarn` in the `node` container
- `xdebug` in the `php` container
- `mailhog` for local mail capture

No application code is bundled with this kit. Mount your own project into `APP_HOST_PATH`.

## Quick Start

```bash
cp .env.example .env
docker compose up -d --build
```

If you copy the kit files into your project root, the default `APP_HOST_PATH=.` mounts that project. If you keep the kit in a subdirectory such as `docker/`, set `APP_HOST_PATH=..`.

Before starting the stack, set a unique `APP_NAME` and unique host ports in `.env` for every project you want to run at the same time.

Open the application at `http://localhost:<APP_HTTP_PORT>` after the stack has started.

If `APP_HOST_PATH` does not contain an application with a `public/` web root, Nginx will respond with `404 Not Found`. That is expected for an empty mount path.

MailHog is available at `http://localhost:<MAILHOG_HTTP_PORT>`.

## Directory Layout

```text
.
├── .env.example
├── compose.yaml
├── nginx/
│   └── templates/
├── node/
└── php/
```

## Configuration

The main values in `.env` are:

- `APP_NAME`: used for the Compose project, container, network, and volume naming
- `APP_HOST_PATH`: host path mounted into app-related containers
- `APP_CONTAINER_PATH`: in-container application path
- `APP_HTTP_PORT`: exposed HTTP port for Nginx
- `NGINX_WEB_ROOT`: in-container path Nginx serves, usually `<APP_CONTAINER_PATH>/public`
- `MYSQL_*`: MySQL database credentials
- `REDIS_PORT`: exposed Redis port
- `XDEBUG_*`: Xdebug settings for IDE integration
- `*_IMAGE_TAG`, `PHP_VERSION`, `PHP_VARIANT`, `NODE_VERSION`, and `NODE_VARIANT`: container image versions and variants

`APP_NAME` must be a Docker Compose-compatible project name: use lowercase letters, numbers, hyphens, or underscores, and start with a letter or number.

## Side-by-Side Projects

For project A named `thebest`:

```dotenv
APP_NAME=thebest
APP_HTTP_PORT=8080
MYSQL_PORT=3307
REDIS_PORT=6379
MAILHOG_SMTP_PORT=1025
MAILHOG_HTTP_PORT=8025
```

For project B named `theworst`:

```dotenv
APP_NAME=theworst
APP_HTTP_PORT=8081
MYSQL_PORT=3308
REDIS_PORT=6380
MAILHOG_SMTP_PORT=1026
MAILHOG_HTTP_PORT=8026
```

Inside each stack, service hostnames stay the same (`mysql`, `redis`, `mailhog`, and so on). Only the host-facing names, volumes, networks, and ports need to be unique.

## Version Defaults

These defaults were checked on 16 May 2026:

- `NGINX_IMAGE_TAG=1.30.1-alpine`: latest Nginx Open Source stable release line.
- `PHP_VERSION=8.5`: latest actively supported PHP branch. PHP uses active/security support windows rather than an LTS label.
- `NODE_VERSION=24`: latest Node.js LTS release line.
- `MYSQL_IMAGE_TAG=9.7`: latest MySQL LTS release line. Use `8.4` if your app or dependencies are not ready for MySQL 9.7.
- `REDIS_IMAGE_TAG=8.6-alpine`: latest stable Redis official Docker line. Redis Open Source does not use the same LTS model.
- `MAILHOG_IMAGE_TAG=v1.0.1`: current MailHog image tag used by the kit. MailHog does not publish an LTS track.

## Service Access

Internal Docker hostnames:

- `php`
- `mysql`
- `redis`
- `mailhog`
- `node`
- `nginx`

Typical examples from inside the stack:

- MySQL host: `mysql`
- Redis host: `redis`
- SMTP host: `mailhog`
- Application URL from other containers: `http://nginx`

## Common Commands

```bash
# Install PHP dependencies
docker compose exec php composer install

# Install Node dependencies in your project
docker compose exec node yarn install

# Run the kit smoke test
./smoke-test.sh
```

## Notes

- No sample app, frontend bundler, or browser test package is included. Add those to your application if you need them.
- `APP_HOST_PATH` defaults to `.`, which assumes the kit files live in the project root.
- Your mounted application is expected to provide a `public/` directory for Nginx to serve from.
- The Node image installs `yarn` globally so JavaScript tooling can be added by the mounted application.
