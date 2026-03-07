# Nginx / PHP / MySQL / Redis / Node Starter Kit

Docker starter kit for PHP applications that need Nginx, MySQL, Redis, and a separate Node container for frontend tooling.

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

Update `APP_HOST_PATH` in `.env` so it points at your application directory before starting the stack.

Open the application at `http://localhost:<APP_HTTP_PORT>` after the stack has started.

If `APP_HOST_PATH` does not contain an application with a `public/` web root, Nginx will respond with `404 Not Found`. That is expected for an empty mount path.

MailHog is available at `http://localhost:<MAILHOG_HTTP_PORT>`.

## Directory Layout

```text
.
├── .env.example
├── compose.yaml
├── nginx/
├── node/
└── php/
```

## Configuration

The main values in `.env` are:

- `APP_NAME`: used for container, network, and volume naming
- `APP_HOST_PATH`: host path mounted into app-related containers
- `APP_CONTAINER_PATH`: in-container application path
- `APP_HTTP_PORT`: exposed HTTP port for Nginx
- `MYSQL_*`: MySQL database credentials
- `REDIS_PORT`: exposed Redis port
- `XDEBUG_*`: Xdebug settings for IDE integration

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
```

## Notes

- No sample app, frontend bundler, or browser test package is included. Add those to your application if you need them.
- `APP_HOST_PATH` defaults to `./app`, but you should update it to wherever your real project lives.
- Your mounted application is expected to provide a `public/` directory for Nginx to serve from.
- The Node image installs `yarn` globally so JavaScript tooling can be added by the mounted application.
