# syntax=docker/dockerfile:1

# -----------------------
# Builder stage
# -----------------------
ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE} AS builder

LABEL org.opencontainers.image.source="https://github.com/c-man-the-man/mastchain-ais"
LABEL org.opencontainers.image.description="Multi-arch Docker image for MastChain AIS using AIS-catcher"
LABEL org.opencontainers.image.version="v1.0.0"

# Build dependencies
RUN apt-get update && apt-get install -y \
    git cmake make build-essential pkg-config \
    librtlsdr-dev \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build AIS-catcher
RUN git clone https://github.com/jvde-github/AIS-catcher.git /src \
    && mkdir /src/build \
    && cd /src/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SSL=ON .. \
    && make -j$(nproc)

# -----------------------
# Runtime stage
# -----------------------
FROM ${BASE_IMAGE}

# Runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    librtlsdr0 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Copy built binary from builder
COPY --from=builder /src/build/AIS-catcher /usr/local/bin/AIS-catcher

# Working directory for persistent data volume
WORKDIR /data

# Entry point for AIS-catcher
ENTRYPOINT ["/usr/local/bin/AIS-catcher"]
