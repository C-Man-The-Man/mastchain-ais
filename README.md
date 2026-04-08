# MastChain AIS Docker Image

## 🚀 Important Update - v1.2.0 (April 2026)

**Major improvement:**  
We have switched the build source from the original `jvde-github/AIS-catcher` to the official **MastChain `mastradar`** fork (`https://github.com/mastchain/mastradar`).

**What changed:**
- Added official **keep-alive / heartbeat** feature.
- Your station will now stay **permanently Online** on the MastChain dashboard — even if it receives zero AIS messages (perfect for inland testers or low-traffic areas).
- All previous functionality (RTL-SDR only, web viewer, GPS support on `/dev/ttyACM1`, config.json, etc.) remains **100% unchanged and compatible**.

**For users:**  
Just run:
```bash
docker compose pull && docker compose up -d
```

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
  -e TZ=YOUR-TIMEZONE \
  -p 8100:8100 \
  --device /dev/bus/usb:/dev/bus/usb \
  -v "$(pwd)/config.json:/data/config.json:ro" \
  -v mastchain_data:/data \
  ghcr.io/c-man-the-man/mastchain-ais:latest \
  -C /data/config.json \
  -H https://api.mastchain.io/api/upload USERPWD YOUR-MASTCHAIN-EMAIL:TOKEN INTERVAL 60 \
  -p 0 \
  -v 30 \
  -N 8100 share_loc off use_gps on
```

**Notes and parameters**
- Replace `YOUR-TIMEZONE` with the host's timezone.
- Replace `YOUR-MASTCHAIN-EMAIL:TOKEN` with your **MastChain** credentials (email:token).
- `-p` flag enables frequency correction in PPM (0=no correction).
- `-v` flag enables verbose interval in seconds (min 5, max 3600)
- `-N` flag enables the **HTML Web Viewer** at the designed TCP port (default 8100); to change the port, match with the exposed port `-p` (`-p 8100:8100` <-> `-N 8100`)
- `share_loc` (default `off`, privacy reasons) and `usg_gps`(default `on`) subcommands enable GPS NMEA sharing and respectively reading for the Web Viewer 
- The Web Viewer can be accessed at: http://host-ip:port.
- Optional, add `-X UUID` to share the data with the community feed at https://www.aiscatcher.org/.
- Optional, add `-e baudrate serial_device` to read GPS NMEA data from a GPS module (requires a GPS module attached to the host).

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

- Replace `YOUR-TIMEZONE` with the host's timezone.
- Replace `YOUR-MASTCHAIN-EMAIL:TOKEN` with your **MastChain** credentials (email:token).
- Additional parameters explained by the Quick Setup section.
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
- Decimals allowed (example: 21.7)
- Decimal values between 0 and 50

`"bandwidth": 19200`
- RF bandwidth (Hz) 
- Default 192000
- Lower values reduce noise
- Set to 0 for auto
- Integer values between 0 and 1,000,000
- RTL-SDR internally rounds to supported values

`"sample_rate": 1536000`
- RTL-SDR sample rate (Hz)
- Recommended 1536000 (best performance)
- Set to 288000 for low CPU usage
- Integer numbers between 0 and 20,000,000

`"freqoffset": 0`
- Frequency correction (PPM)
- Use if the dongle is frequency shifted
- Positive or negative integer values allowed
- 0 means no correction
- Integer values between -150 and 150

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
- Can expose GPS location

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
