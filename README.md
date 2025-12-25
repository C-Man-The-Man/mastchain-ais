# MastChain AIS Docker Image

This repository provides a **multi-architecture Docker image** for running [AIS-catcher](https://github.com/jvde-github/AIS-catcher) as a [MastChain](https://mastchain.io) compatible AIS receiver and uploader.

It supports **amd64** and **arm64**, making it suitable for Raspberry Pi, Linux servers, and Docker Desktop.

---

## Features

- **Multi-architecture:** amd64 and arm64
- **SSL-enabled** for HTTPS uploads to MastChain
- **Docker Compose ready**
- **Persistent data storage** via Docker volumes
- **HTML Web Viewer** view live AIS data in your browser

---

## Supported Platforms

- Linux x86_64 (amd64)
- Linux arm64 (Raspberry Pi 4 / 5, 64-bit OS)
- Docker Desktop (Mac / Windows / Linux)

---

## Quick Setup (Docker CLI)

```bash
docker run -d \
  --name mastchain-ais \
  --restart unless-stopped \
  --device /dev/bus/usb:/dev/bus/usb \
  -p 8100:8100 \
  -v mastchain_data:/data \
  ghcr.io/c-man-the-man/mastchain-ais:latest \
  -v 30 \
  -N 8100 \
  -H https://api.mastchain.io/api/submit \
  USERPWD <your-mastchain-token> \
  INTERVAL 60 \
  --logfile /data/aiscatcher.log \
  --loglevel info
```
- Replace <your-mastchain-token> with your MastChain credentials.
- The -N 8100 flag enables the HTML Web Viewer on port 8100 (the port can be changed).
- The Web Viewer can be accessed at: http://<host-ip>:8100.

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

### Create the YAML file

```bash
nano docker-compose.yml
```
- Copy the contents of this repository’s docker-compose.yml 
- Replace your MastChain credentials (email:token) 
- Save and exit the file (press **CTRL+O** and **Enter** to save, **CTRL+X** to exit).

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

## HTML Web Viewer

- Port: 8100 (changeable, depending on local needs)
- Access: http://<host-ip>:8100
- Shows live AIS traffic and engine status
- Works on any device with a browser
- No login required
- Only requires the container to be running with -N 8100 and the port exposed

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
