# arm64 Docker container for lighttpd
[![Docker Image Size](https://img.shields.io/docker/image-size/laurazepam/arm64-lighttpd/latest)](https://hub.docker.com/repository/docker/laurazepam/arm64-lighttpd/tags) [![GitHub Release](https://img.shields.io/github/v/release/Laurazepam/arm64-lighttpd?color=orange)](https://github.com/Laurazepam/arm64-lighttpd/releases/latest) [![Docker Pulls](https://img.shields.io/docker/pulls/laurazepam/arm64-lighttpd?color=purple)](https://hub.docker.com/r/laurazepam/arm64-lighttpd) [![Maintained](https://img.shields.io/maintenance/yes/2022)]()

This is an arm64 compatible Docker container for [lighttpd](https://www.lighttpd.net/).

---

Lighttpd is a lightweight and fast, yet capable web server. This container is meant for serving small static websites (e.g. your personal website) from a RaspberryPi (3B+ or later) or other arm based SBCs.

## Usage

**NOTE**: The Docker command provided is just an example
and should be adjusted to your own needs.

Launch the lighttpd docker container with the following command:
```
docker run -d \
    --name=lighttpd \
    -p 888:80 \
    -v /docker/lighttpd/www:/srv/www:rw \
    -v /docker/lighttpd/config:/etc/lighttpd:rw \
    laurazepam/arm64-lighttpd
```

Where:
  - `/docker/lighttpd`: Location of configuration and web files
  - `888`: Published port of the container (this is where you will find your pages)
