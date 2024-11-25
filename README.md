# VPN Sandbox

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/vm75/docker-boilerplate)](https://hub.docker.com/r/vm75/docker-boilerplate)
[![Build Status](https://img.shields.io/github/actions/workflow/status/vm75/docker-boilerplate/.github/workflows/ci.yml?branch=main)](https://github.com/vm75/docker-boilerplate/actions)

**Docker boilerplate** Starter project for a new Docker project.

## Key Features

- **TODO**: TODO.

## Getting Started

### Prerequisites

- Install Docker or Podman.
- Configure a persistent volume for `/data`.

### Quick Start

Pull the Docker image and run the container:
```bash
docker pull docker-boilerplate/docker-boilerplate
docker run -d --name docker-boilerplate \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  -v /path/to/data:/data \
  -p 8080:8080 \
  docker-boilerplate/docker-boilerplate
```

### Example `docker-compose.yml`
Here's an example configuration for Docker Compose:
```yaml
services:
  docker-boilerplate:
    image: docker-boilerplate/docker-boilerplate
    container_name: docker-boilerplate
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    ports:
      - "8080:8080" # API
    volumes:
      - /path/to/data:/data
    restart: unless-stopped
```

Start the service with:
```bash
docker-compose up -d
```

## Volume Structure

The `/data` volume should contain the following structure:
```plaintext
/data
├── test.db         # SQLite database
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


---

Contributions are welcome! 🚀