# syntax=docker/dockerfile:1

ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS builder

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
# Runtime image
# -----------------------
FROM ${BASE_IMAGE}

# Runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    librtlsdr0 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Copy built binary
COPY --from=builder /src/build/AIS-catcher /usr/local/bin/AIS-catcher

# Set working directory
WORKDIR /data

# Set entrypoint so arguments go to AIS-catcher
ENTRYPOINT ["/usr/local/bin/AIS-catcher"]
