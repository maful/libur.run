<p align="center">
  <a href="https://libur.run" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/maful/libur.run/HEAD/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/maful/libur.run/HEAD/.github/logo-light.svg">
      <img alt="Libur.run" src="https://raw.githubusercontent.com/maful/libur.run/HEAD/.github/logo-light.svg" width="180" height="41" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  Empower Your HR with Next-Gen Open Source Self-Serve Platform
</p>

<p align="center">
  <a href="https://github.com/maful/libur.run/actions"><img alt="Build Status" src="https://img.shields.io/github/actions/workflow/status/maful/libur.run/ci.yml?branch=main"></a>
  <a href="https://github.com/maful/libur.run/releases"><img alt="Release" src="https://img.shields.io/github/v/release/maful/libur.run?include_prereleases&sort=semver"></a>
  <a href="https://github.com/maful/libur.run/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/maful/libur.run"></a>
</p>

------

## Installation

To install Libur.run, please follow the instructions provided below. Once you've installed and set up the platform, you'll be able to start managing your HR needs with ease. The following installation is manual, meaning you have responsibilty for the requirements. If you are using Docker, you can follow the installation [with Docker](#with-docker).

### Prerequisites

Before you install and start using Libur.run, please make sure your system meets the following requirements:

- Ruby version 3.1.2
- Node.js 16 or newer
- PostgreSQL 14 or newer
- Redis 6 or newer

### Getting Ready
1. Give a star to support this project on GitHub :)
1. Before you start, make sure you have Ruby 3.1.2, PostgreSQL, and Redis installed on your machine.
1. Clone or download the Libur.run repository.
1. Start the PostgreSQL and Redis databases, and make note of the credentials for each database as you'll need to configure the application later.
1. Navigate to the application directory and copy the `.env.example` file to `.env` with `cp .env.example .env`.
1. Open the `.env` file and change the `REDIS_URL` to your local Redis database (usually `redis://localhost:6379/1`).
1. Update the `DATABASE_*` environment variables with the correct values for your PostgreSQL database.
1. Don't forget to set the `RAILS_MASTER_KEY`, as it will be used for encryption.
1. Finally, install the dependencies by running `bundle install` and `yarn install`.

### Database Setup

1. Open your terminal and navigate to the Libur.run application directory.
1. Create the application database by running the following command: `rails db:create`
1. Migrate the schema by running the following command: `rails db:migrate`. If any errors occur, double-check your database configuration in the application.
1. Populate some initial data before starting the application by running the following command: `rails db:seed`

### Run the application

1. Open your terminal and run `./bin/dev` to start the application.
1. Wait until all processes are complete.
1. Open your browser and access `localhost:3000`. You're now ready to start using Libur.run. Welcome!

## With Docker

Installing Libur.run with Docker makes the process easy and smooth. To get started, make sure that Docker is installed on your machine and that [Docker Compose V2](https://www.docker.com/blog/announcing-compose-v2-general-availability/) is enabled. You can find the `Dockerfile` and `compose.yml` files in the root directory of the Libur.run repository.

Here are the steps to install Libur.run with Docker:

1. Give a star to support this project on GitHub :)
1. Ensure that Docker is running on your machine, and open a terminal and navigate to the application directory.
1. Create `.env` file by running `cp .env.example .env` and then set the `DATABASE_HOST` to `db` and `REDIS_URL` to `redis://redis:6379/1` in `.env` file.
1. Don't forget to set the `RAILS_MASTER_KEY`, as it will be used for encryption.
1. Build the image by running `docker compose build`. Wait until the process is complete.
1. Start the application by running `docker compose up` or `docker compose up -d` to run the containers in the background (detached mode).
1. To set up the database, open a new terminal window (if you're not using detached mode) and run `docker compose exec web bin/rails db:setup`.
1. Once the database is set up, the application will be ready to use. Open your browser and access `localhost:3000`. Enjoy using Libur.run!

### Setting up Account

Getting started with Libur.run is easy! Simply access the URL, if running locally, `localhost:3000`. On the installation page, you'll be guided through a few simple steps to set up your account. Just follow the prompts and you'll be ready to go in no time!

TODO: Add Installation Video

## Deployment to Production

Work in progress

## Contributing

If you're interested in contributing to Libur.run, please read our [contributing docs](https://github.com/maful/libur.run/blob/main/.github/CONTRIBUTING.md) **before submitting a pull request**.

## License

Libur.run is open-source software licensed under the MIT License. This means you're free to use, modify, and distribute the software as you see fit, subject to certain conditions outlined in the license. For more details, please see the [LICENSE](https://github.com/maful/libur.run/blob/main/LICENSE) file.
