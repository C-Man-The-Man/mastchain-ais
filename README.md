# MastChain AIS Docker Image

This repository provides a **multi-architecture Docker image** for running [AIS-catcher](https://github.com/jvde-github/AIS-catcher) as a [MastChain](https://mastchain.io) compatible AIS receiver and uploader.

It supports **AMD64** and **ARM64**, making it suitable for Raspberry Pi, Linux servers, and Docker Desktop.

---

## Features

- **Multi-architecture:** AMD64 and ARM64
- **SSL-enabled** for HTTPS uploads to MastChain
- **Docker Compose ready**
- **Persistent data storage** via Docker volumes
- **HTML Web Viewer** view live AIS data in your browser
- **User-editable receiver configuration** (config.json)

---

## Supported Platforms

- Linux x86_64 (AMD64)
- Linux arm64 (Raspberry Pi 4 / 5, 64-bit OS)
- Docker Desktop (Mac / Windows / Linux)

---

## Quick Setup

### Create a working directory

```bash
mkdir mastchain-ais && cd mastchain-ais
```

### Download the configuration file

```bash
curl -O https://raw.githubusercontent.com/c-man-the-man/mastchain-ais/main/config.json
```

#### Edit the configuration **parameters** if needed:

```bash
nano config.json
```

- The configuration parameters explanation can be found lower.
- To save press **CTRL+O** and **Enter**, to exit press **CTRL+X**.

### Run the container

```bash
docker run -d \
  --name mastchain-ais \
  --restart unless-stopped \
  --device /dev/bus/usb:/dev/bus/usb \
  -p 8100:8100 \
  -v $(pwd)/config.json:/data/config.json:ro \
  -v mastchain_data:/data \
  ghcr.io/c-man-the-man/mastchain-ais:latest \
  -v 30 \
  -N 8100 \
  -C /data/config.json \
  -H https://api.mastchain.io/api/upload USERPWD <YOUR-MASTCHAIN-TOKEN> INTERVAL 60 \
  --logfile /data/aiscatcher.log \
  --loglevel info
```

**Notes**
- Replace `<YOUR-MASTCHAIN-TOKEN>` with your **MastChain** credentials (email:token).
- The `-N 8100` flag enables the **HTML Web Viewer** on port 8100 (the port can be changed in the CLI, use the same for the `-p` and `-N` flags).
- The Web Viewer can be accessed at: http://host-ip:8100.

---

## Docker Compose Setup (recommended)

### Create a working directory

```bash
mkdir ~/mastchain-ais && cd ~/mastchain-ais
```

### Pull the latest image

```bash
docker pull ghcr.io/c-man-the-man/mastchain-ais:latest
```

### Download the YAML file

```bash
curl -O https://raw.githubusercontent.com/C-Man-The-Man/mastchain-ais/refs/heads/main/docker-compose.yml
```

#### Edit the YAML file

```bash
nano docker-compose.yml
```

- Replace `<YOUR-MASTCHAIN-TOKEN>` with your **MastChain** credentials (email:token).
- To save press **CTRL+O** and **Enter**, to exit press **CTRL+X**.

### Download the configuration file

```bash
curl -O https://raw.githubusercontent.com/c-man-the-man/mastchain-ais/main/config.json
```

#### Edit the configuration **parameters** if needed:

```bash
nano config.json
```

- The configuration parameters explanation can be found lower.
- To save press **CTRL+O** and **Enter**, to exit press **CTRL+X**.

### Start the container

```bash
docker compose up -d
```

### View logs

```bash
docker compose logs -f
```

### Stop and remove the container

```bash
docker compose down
```

---

## Configuration file parameters explanation

`"config": "aiscatcher"`
- Don't change, this image is an **AIS-Catcher-Control** fork, must be "aiscatcher"

`"version": 1`
- The version of the **AIS-Catcher-Control** configuration file, only 1 is supported currently

`"input": "RTLSDR"`
- Must remain "RTLSDR" for the **MastChain** project

`"tuner": "auto"`
- Gain control: "auto" or 0–50 (recommended: "auto")
- Higher values increase sensitivity but may introduce noise
- Decimals allowed (example: 25.5)

`"bandwidth": 19200`
- RF bandwidth (Hz) 
- Default 192000
- Lower values reduce noise
- Set to 0 to disable
- RTL-SDR internally rounds to supported values

`"sample_rate": 1536000`
- RTL-SDR sample rate (Hz)
- Recommended 1536000 (best performance)
- Set to 288000 for low CPU usage
- Use a custom value (not recommended)

`"freqoffset": 0`
- Frequency correction (Hz)
- Use if the dongle is frequency shifted
- Positive or negative integer values allowed
- 0 means no correction
- Value is applied in Hz, not PPM, typical values range from -100 to +100

`"biastee": false`
- Powers active antennas (set "true" for ON, set "false" for OFF)
- Only enable if the hardware supports it

`"rtlagc": true`
- RTL-SDR automatic gain control (set "true" for ON, set "false" for OFF)
- ON - recommended
- OFF - manual tuning only

`"verbose": true`
- Detailed receiver logs if set to "true"
- Useful for debugging and tuning

---

## HTML Web Viewer

- Port: 8100 (changeable, depending on local needs)
- Access: http://host-ip:8100
- Shows live AIS traffic and engine status
- Works on any device with a browser
- No login required
- Only requires the container to be running with -N 8100 and the port exposed
- Recommended for diagnostics and tuning

---

## Help & Community

A more detailed guide and community support are available on my [Discord Server](https://discord.com/invite/wY3N2hCT3u).

---

## Notes

- A [MastChain account](https://app.mastchain.io/) is needed prior.
- USB access is required for RTL-SDR devices: `--device /dev/bus/usb:/dev/bus/usb`.
- The image automatically selects the correct architecture (amd64 or arm64).
- SSL support is enabled for secure HTTPS submissions to MastChain.
- The image does not modify nor store credentials internally.
- Configuration is always user owned.

---

## License & Credits
- **AIS-catcher** is developed by [jvde-github](https://github.com/jvde-github/AIS-catcher) and contributors.
- This Docker image packages **AIS-catcher** for **MastChain** compatible use.
