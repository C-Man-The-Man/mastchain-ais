# MastChain AIS Docker Image

This repository provides a **multi-architecture Docker image** for running [AIS-catcher](https://github.com/jvde-github/AIS-catcher) as a [MastChain](https://mastchain.io) compatible AIS receiver and uploader.

It supports **amd64** and **arm64**, making it suitable for Raspberry Pi, Linux servers, and Docker Desktop.

---

## Features

- **Multi-architecture:** amd64 and arm64
- **SSL-enabled** for HTTPS uploads to MastChain
- **Docker Compose ready**
- **Persistent data storage** via Docker volumes

---

## Supported Platforms

- Linux x86_64 (amd64)
- Linux ARM64 (Raspberry Pi 4 / 5, 64-bit OS)
- Docker Desktop (Mac / Windows / Linux)

---

## Quick Setup (Docker CLI)

```bash
docker run -d \
  --name mastchain-ais \
  --restart unless-stopped \
  --device /dev/bus/usb:/dev/bus/usb \
  -v mastchain_data:/data \
  ghcr.io/c-man-the-man/mastchain-ais:latest \
  -v 30 \
  -H https://api.mastchain.io/api/submit \
  USERPWD <your-mastchain-token> \
  INTERVAL 60
```
Replace <your-mastchain-token> with your MastChain credentials.

---

## Docker Compose Setup

### Create and navigate to a directory

```bash
mkdir ~/mastchain-ais && cd ~/mastchain-ais
```

### Pull the latest image

```bash
docker pull ghcr.io/c-man-the-man/mastchain-ais:latest
```

### Create the Compose file

```bash
nano docker-compose.yml
```

### Copy the contents of this repository’s docker-compose.yml, replace your MastChain token, then save the file.

### Start the container

```bash
docker compose up -d
```

### View logs

```bash
docker compose logs -f
```

### To stop and remove the container

```bash
docker compose down
```

---

## Help & Community

A more detailed guide and community support are available on my [Discord Server](https://discord.com/invite/wY3N2hCT3u).

---

## Notes

- A [MastChain account](https://app.mastchain.io/) is needed prior.
- USB access is required for RTL-SDR devices: `--device /dev/bus/usb:/dev/bus/usb`.
- The image automatically selects the correct architecture (amd64 or arm64).
- SSL support is enabled for secure HTTPS submissions to MastChain.

---

## License & Credits
- AIS-catcher is developed by [jvde-github](https://github.com/jvde-github/AIS-catcher) and contributors.
- This Docker image packages AIS-catcher for MastChain compatible use.
