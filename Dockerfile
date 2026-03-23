# syntax=docker/dockerfile:1
FROM rust:1-slim-bookworm AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY xtask ./xtask
COPY agents ./agents
COPY packages ./packages
RUN cargo build --release --bin openfang

FROM debian:bookworm-slim

# Install dependencies required for HF Spaces Dev Mode and OpenFang
RUN apt-get update && apt-get install -y \
    ca-certificates \
    bash \
    curl \
    wget \
    procps \
    git \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Set up user with UID 1000
RUN useradd -m -u 1000 user

WORKDIR /app

# Configure OpenFang home directory
ENV OPENFANG_HOME=/app/data
RUN mkdir -p /app/data/agents /app/data/skills && chown -R user:user /app

# Copy binary and agents
COPY --from=builder --chown=user:user /build/target/release/openfang /usr/local/bin/

# Copy agents to the configured home directory
COPY --from=builder --chown=user:user /build/agents /app/data/agents

USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:/usr/local/bin:$PATH

EXPOSE 7860

# Use CMD for startup as required by HF Dev Mode
CMD ["openfang", "start"]
