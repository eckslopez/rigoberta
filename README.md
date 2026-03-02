# Rigoberta

Rigoberta is a narrative reference app: "This is how I build a modern Rails service in 2026." It is intentionally small, teachable, and inspectable. The goal is not features; the goal is clarity and a repeatable standard you can fork.

Repository Category: `tenant` (see `platform-docs/_platform/REPO_TAXONOMY.md`)

Documentation authority boundary:
- This repository documents workload implementation and operations for this tenant.
- Platform governance, lifecycle, and contract doctrine remain authoritative in `platform-docs/_platform/`.

## What this is

- A gold-standard Rails 7 service template
- A living example of CI, security, and Docker-first development
- A companion to write-ups like "My default Rails stack" and "Rails in a GitOps world"

## What this is not

- A product roadmap
- A grab-bag of experiments
- A long-lived monolith

## Part of ZaveStudios Platform

This application runs as a tenant on the [ZaveStudios multi-tenant platform](link).

**Platform integration:**
- Namespace: `<app-name>` (isolated Kubernetes namespace)
- Database: `db_<app-name>` tenant in [pg-multitenant](link)
- Deployment: ArgoCD GitOps via [kubernetes-platform-infrastructure](link)
- Observability: Shared Prometheus/Grafana

## Goals

- Be the cleanest, smallest Rails 7 reference service you can fork
- Keep the stack modern without being trendy
- Make CI, security, and Docker part of the happy path
- Document the "why" as much as the "how"

## Zave Value Filter (Decision Gate)

Every planned change in this app must satisfy at least one of these:

- Improves a ZaveStudios platform capability
- Teaches a reusable pattern for tenant apps
- Reduces operational risk (security, observability, or deployment reliability)
- Speeds up delivery for future ZaveStudios services

If a task does not pass this filter, do not prioritize it.

## Tech stack (current)

- Rails 7
- Ruby 3
- PostgreSQL
- Redis
- Docker + Docker Compose

## Resurrection plan (GitHub issues)

Create these as issues and track them in order:

1) Inventory and docs baseline
- Update README narrative and scope (this doc)
- Add goals and non-goals section
- Document local dev workflow and required env vars

2) Dependency and security refresh
- Bundle update and resolve any deprecations
- Run Brakeman + bundler-audit; fix findings
- Confirm Ruby/Rails versions in `Gemfile` and CI matrix

3) Docker Compose happy path
- Verify `docker compose build` and `docker compose up`
- Ensure db setup and migrations run cleanly
- Add a short "first run" troubleshooting note

4) Test and lint baseline
- Ensure rspec passes in Docker
- Align RuboCop config with current Ruby/Rails

5) CI and security pipeline (to be plugged in)
- Add GitHub Actions workflows for tests, lint, security checks, and image build
- Make CI the required gate for merges

6) Release discipline
- Add Dependabot configuration for gems and GitHub Actions
- Document release notes format (if needed)

7) Branch protections and merge flow
- Protect `main`: require CI checks and up-to-date branches
- Enable auto-merge after CI for approved PRs

## Local development

### Requirements

Docker Compose v2 is required (use `docker compose`, not `docker-compose`).

Check your version with:
```
$ docker compose version
```

### Initial setup
```
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:setup
```

### Run the app
```
docker compose up
```

### Rails console
```
# When the app is already running
$ docker compose exec web bin/rails c

# Or run a one-off console
$ docker compose run --rm web bin/rails c
```

### Run tests
```
docker compose run --rm web bin/rspec
```

### Update gems
```
docker compose run --rm web bundle update
docker compose up --build
```

### Troubleshooting

- First run can take several minutes while gems install.
- If you see "The following gems are missing", run `docker compose run --rm web bundle install` and retry `docker compose run --rm web bin/rails db:setup`.
- If the app can’t connect to Postgres, ensure `.env` exists with `PGHOST=db` and the password matches `POSTGRES_PASSWORD` in `docker-compose.yml`.
- If port 3000 is in use, change the host port in `docker-compose.yml` (e.g., `3001:3000`).


## CI flow

- Feature branches: tests, lint, and security scans run on push and PRs.
- Main branch: image build runs after merge.
- Branch protection requires checks before merging to `main`.

## Production build

```
DOCKER_BUILDKIT=1 docker build --tag rigoberta --file production.Dockerfile . --load
```

## Credits/References

- Rails + Docker: Compose and Rails quickstart, Ruby on Whales
- Hotwire/Stimulus/Turbo references

## Author

Ryan Williams

- ryanwilliams.dev
- github.com/ryanwi
