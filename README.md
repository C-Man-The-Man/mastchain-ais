# MastChain AIS Docker Image

## 🚀 Important Update - v1.2.0 (April 2026)

**Major improvement:**
The build source switched from the original `jvde-github/AIS-catcher` to the official [**MastChain's mastradar fork](https://github.com/mastchain/mastradar).

**What changed:**
- Added official **keep-alive / heartbeat** feature.
- Your station will now stay **permanently Online** on the MastChain dashboard — even if it receives zero AIS messages (perfect for inland testers or low-traffic areas).
- All previous functionality (RTL-SDR only, web viewer, GPS support on `/dev/ttyACM0`, config.json, etc.) remains **100% unchanged and compatible**.

### For users:

#### Quick setup users (docker run command)

- stop and remove the container

```bash
docker stop mastchain-ais
docker rm mastchain-ais
```

- run the container command from the **Quick Setup** section from this guide


#### Advanced setup users (docker compose) - commands inside the working directory

- stop and remove the container

```bash
docker compose down
```

- pull the new image and run the container

```bash
docker compose pull && docker compose up -d
```

- check the **Advanced Recommended Setup** section for more info

---

This repository provides a **multi-architecture Docker image** for running [AIS-catcher](https://github.com/jvde-github/AIS-catcher) as a [MastChain](https://app.mastchain.io/auth/sign-in?ref=xeX9FeN5) compatible AIS receiver and uploader.

It supports **AMD64** and **ARM64**, making it suitable for Raspberry Pi, Linux servers, and Docker Desktop.

---

## Recommended use

Use this build with the [**MastChain Configuration Script**](https://github.com/C-Man-The-Man/mastchain-config) one for automation.

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
- Optional, add at the end `-X UUID` to share the data with the community feed at https://www.aiscatcher.org/.
- Optional, add at the end `-e baudrate serial_device` to read GPS NMEA data from a GPS module (requires a GPS module attached to the host);
   - use
   ```bash
   stty -F /dev/ttyACM0
   ```
   to find out the baud speed rate of the GPS module.

---

## Advanced Recommended Setup (docker compose)

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
- using a different SDR should be supported automatically, contrary, use the one of **hardware supported input options**:
   - RTL SDR: `"RTLSDR"` (default)
   - Airspy: `"airspy"`
   - Airspy HF+: `"airspyhf"`
   - HackRF: `"hackrf"`
   - SDRplay: `"sdrplay"`
   - SoapySDR: `"soapysdr"`
   - HydraSDR: `"hydrasdr"`
- examples of usage in the `config.json` file

   ```bash
   "input": "RTLSDR",
   "rtlsdr": {
   ```

   ```bash
   "input": "airspy",
   "airspy": {
   ```

   etc.
   
- Warning: not all the presented parameters are compatible with all the supported input hardware, the following ones and their values are for the *RTL SDR* ones

`"tuner": "auto"`
- Gain control: "auto" or 0–50 (recommended: "auto")
- Higher values increase sensitivity but may introduce noise
- Decimals allowed (example: 21.7)
- Decimal values between 0 and 50

`"bandwidth": 0`
- RF bandwidth (Hz) 
- Default 0
- Set to 0 for no bandwidth filter (suited for most setups)
- Integer values between 0 and 1,000,000
- RTL-SDR internally rounds to supported values

`"sample_rate": 1536000`
- RTL-SDR sample rate (Hz)
- Recommended 1536000 (best performance)
- Set to `288000` for low CPU usage
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

- A [**MastChain account**]([https://app.mastchain.io/](https://app.mastchain.io/auth/sign-in?ref=xeX9FeN5)) is needed prior (referral link, support my work, thank you).
- USB access is required for RTL-SDR devices: `--device /dev/bus/usb:/dev/bus/usb`.
- The image automatically selects the correct architecture (amd64 or arm64).
- SSL support is enabled for secure HTTPS submissions to MastChain.
- The image does not modify nor store credentials internally.
- Configuration is always user owned.

---

## License & Credits
- **AIS-catcher** is developed by [jvde-github](https://github.com/jvde-github/AIS-catcher) and contributors.
- This Docker image packages a minimalistic **AIS-catcher** for **MastChain** compatible use.

---

## Donations

**Bitcoin wallet address**
```text
bc1qpcfex53u7mqx4dc25gw7j7446amw9vn6743cn5
```

**EVM / Metamask  (ETH, ETC, OCTA, POL, PEAQ, MONAD, BASE etc.)**
```text
0xbE4879888d95B02B2FCaed2FcAeBbcf36829BDC9
```

**Solana wallet address**
```text
7EHWvShXfjLJ2HhzTf4CsHgjKckivfMQMjnEoUAEqau
```

**Sui wallet address**
```text
0x421a5a462f99c2d675d035d0c741ba5765a47c1e28f95d33ad770cd34a36a6ea
```

**Thank you!**
