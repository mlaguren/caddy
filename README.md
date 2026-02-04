# Caddy Docker Image

## Overview

This repository contains the configuration and setup for building a Docker image for [Caddy](https://caddyserver.com/), a powerful, easy-to-use web server. It includes a Rake-based task system for managing builds and automated tests using `serverspec`.

## Features

- **Caddy Setup:** Builds a Docker image for running the Caddy web server.
- **Automated Testing:** Includes `serverspec` tests to validate the image and functionality.
- **Flexible Configuration:** Modular `Rake` tasks for testing specific scenarios or configurations.

## Prerequisites

To use or contribute to this repository, ensure you have:

- **Docker** installed. [Get Docker here](https://www.docker.com/get-started).
- **Ruby** 3.3.5 with [rbenv](https://github.com/rbenv/rbenv).
- **Bundler** >= 2.7.1.

Install necessary dependencies via Bundler:

```bash
bundle install
```

## Building the Docker Image

To build the Docker image for Caddy, run:

```bash
docker build -t caddy-image .
```

This will build the image using the `Dockerfile` provided in the repository.

## Running the Docker Container

Once the image is built, you can run a container with:

```bash
docker run -d -p 80:80 --name caddy-container caddy-image
```

- The Caddy server will be available on `http://localhost:80`.

### Custom Configuration

To use a custom `Caddyfile` configuration:

1. Create your `Caddyfile` in the project directory.
2. Use a bind mount to pass the file into the container:

   ```bash
   docker run -d -p 80:80 \
     -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
     --name caddy-container caddy-image
   ```

## Testing the Docker Image

The testing for this project is built on `serverspec`, a Ruby testing tool designed for infrastructure testing.

### Running All Tests

To execute all the Serverspec tests:

```bash
rake spec:all
```

### Running Specific Tests

Run tests for a specific target directory (e.g., `default` or custom configurations):

```bash
rake spec:default
```

For other subdirectories under `spec/`, specify the directory name:

```bash
rake spec:<target>
# Example:
rake spec:host1
```

### Test Setup

Tests are located in `spec/` and organized by directories. For example: