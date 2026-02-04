# Caddy Docker Image

A lightweight Docker image for the [Caddy](https://caddyserver.com/) web server with automated testing using Serverspec.

## Overview

This project provides a production-ready Caddy web server Docker image based on Debian Stable Slim. The image is configured with a simple health check endpoint and includes comprehensive testing to verify the installation and runtime behavior.

## Features

- **Lightweight**: Based on Debian Stable Slim
- **Official Caddy**: Installs Caddy from the official Cloudsmith repository
- **Automated Testing**: Serverspec tests verify image correctness and runtime behavior
- **Simple Configuration**: Basic Caddyfile included with health check endpoint

## Prerequisites

- Docker
- Ruby (for running tests)
- Bundler

## Installation

Install Ruby dependencies:

```bash
bundle install --path vendor/bundle
```

## Building the Image

Build the Docker image:

```bash
docker build -t caddy .
```

## Running the Container

Run Caddy on port 8080:

```bash
docker run -p 8080:80 caddy
```

Test the endpoint:

```bash
curl http://localhost:8080
# Expected output: ok
```

## Testing

The project includes comprehensive Serverspec tests that verify:

- Caddy installation and version
- Caddyfile presence and validity
- Configuration validation
- Runtime HTTP response behavior

Run all tests:

```bash
bundle exec rake spec
```

Or run specific tests:

```bash
bundle exec rake spec:caddy
```

## Configuration

The default [Caddyfile](Caddyfile) provides a simple health check endpoint:

```caddyfile
:80 {
  respond "ok" 200
}
```

Customize the Caddyfile for your needs and rebuild the image.

## Project Structure

```
.
├── Caddyfile                      # Caddy configuration
├── Dockerfile                     # Docker image definition
├── Gemfile                        # Ruby dependencies
├── Rakefile                       # Test automation tasks
├── README.md                      # This file
└── spec/                          # Test specifications
    └── caddy/
        └── caddyshack_image_spec.rb  # Serverspec tests
```

## Development

The Rakefile provides tasks for running tests:

- `rake spec` - Run all tests
- `rake spec:caddy` - Run Caddy-specific tests

## License

This project is open source. Please check the license file or contact the author for more information.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
