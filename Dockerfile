# syntax=docker/dockerfile:1
FROM rust:1-slim-bookworm AS builder
WORKDIR /build
# Reduce memory usage during build (limit parallel jobs)
ENV CARGO_BUILD_JOBS=1
ENV CARGO_NET_RETRY=10
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY xtask ./xtask
COPY agents ./agents
COPY packages ./packages
RUN cargo build --release --bin openfang

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates python3-requests && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/target/release/openfang /usr/local/bin/
COPY --from=builder /build/agents /opt/openfang/agents
COPY python /opt/openfang/python
EXPOSE 4200
VOLUME /data
ENV OPENFANG_HOME=/data
ENV OPENFANG_LISTEN=0.0.0.0:4200
ENV OPENFANG_DEFAULT_PROVIDER=openai
ENV OPENFANG_DEFAULT_MODEL=alias-large
ENV OPENFANG_DEFAULT_BASE_URL=https://api.helmholtz-blablador.fz-juelich.de/v1
ENTRYPOINT ["openfang"]
CMD ["start"]
