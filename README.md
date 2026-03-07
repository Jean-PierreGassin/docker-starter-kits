# Docker Starter Kits

Reusable Docker-based starter kits for local development.

This repository is for projects that want a clean, repeatable development stack without requiring every runtime and tool to be installed on the host machine. Each kit is intended to be copied, configured with a local `.env`, and pointed at a real application directory.

## What This Repository Is For

- Starting new projects with a known-good Docker setup
- Keeping local tooling inside containers instead of on the host
- Reusing the same configuration patterns across multiple stacks
- Making onboarding faster for contributors

## Principles

- Each service should have a single responsibility.
- Tooling should live in the container that uses it.
- Configuration should be driven by `.env` and documented in `.env.example`.
- Application names, ports, and mount paths should be easy to change.
- Kits should stay practical and minimal, not framework-specific by default.

## Available Kits

### [`nginx-php-mysql-redis-node`](./kits/nginx-php-mysql-redis-node)

Includes:

- Nginx
- PHP-FPM
- Composer
- MySQL
- Redis
- Node.js
- Yarn
- MailHog
- Xdebug

This kit does not include a sample application. You mount your own project into the containers.

## Quick Start

1. Clone the repository.
2. Open the kit you want to use.
3. Copy `.env.example` to `.env`.
4. Update `APP_HOST_PATH` and any ports or credentials you want to change.
5. Start the stack with Docker Compose.

Example:

```bash
cd kits/nginx-php-mysql-redis-node
cp .env.example .env
docker compose up -d --build
```

## Testing

Each kit can provide its own `smoke-test.sh` for end-to-end validation. These smoke tests are intended to catch breakage from Docker image updates, package manager changes, and Compose configuration regressions.

GitHub Actions runs smoke tests only for kits touched by a PR or push when possible. Scheduled and manual runs execute all kit smoke tests.

## Repository Layout

```text
.
├── README.md
└── kits/
    └── nginx-php-mysql-redis-node/
        ├── .env.example
        ├── compose.yaml
        ├── nginx/
        ├── node/
        ├── php/
        └── smoke-test.sh
```

Each starter kit should contain only the files needed to define and run that stack.

## Requirements

- Docker
- Docker Compose
- Git

## Contributing

When adding or updating a kit:

- Keep the layout simple and predictable.
- Avoid bundling example applications unless the kit specifically requires one.
- Put container-specific files in top-level directories named after the container.
- Prefer broadly useful development tooling over framework-specific packages.
- Keep README files practical and task-oriented.
