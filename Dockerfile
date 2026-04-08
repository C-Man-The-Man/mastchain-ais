# syntax=docker/dockerfile:1

ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS builder

# Build dependencies (complete set required by mastradar)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake make build-essential pkg-config \
    librtlsdr-dev \
    libssl-dev \
    libusb-1.0-0-dev \
    libcurl4-gnutls-dev \
    zlib1g-dev \
    libsqlite3-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build AIS-catcher from Mastchain fork (includes keep-alive + DePIN fixes)
RUN git clone https://github.com/mastchain/mastradar.git /src \
    && mkdir /src/build \
    && cd /src/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=ON -DHYDRASDR=OFF .. \
    && make -j$(nproc)

# -----------------------
# Runtime image
# -----------------------
FROM ${BASE_IMAGE}

# Runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    librtlsdr0 \
    libssl3 \
    zlib1g \
    libcurl4 \
    libusb-1.0-0 \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy built binary
COPY --from=builder /src/build/AIS-catcher /usr/local/bin/AIS-catcher

# Set working directory
WORKDIR /data

# Set entrypoint so arguments go to AIS-catcher
ENTRYPOINT ["/usr/local/bin/AIS-catcher"]
