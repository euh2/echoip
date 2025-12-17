# Base image: Build echoip from source
FROM golang:1.21-alpine AS base

# Clone and build echoip
WORKDIR /build
COPY echoip-source /build

RUN apk add --no-cache git && \
    go build -o echoip ./cmd/echoip

# Final image: Copy base image binary and add clean-theme
FROM alpine:latest

# Install ca-certificates for HTTPS
RUN apk add --no-cache ca-certificates

# Copy echoip binary from base image
COPY --from=base /build/echoip /usr/local/bin/echoip

# Copy clean-theme to /opt/clean-theme
COPY ./clean-theme /opt/clean-theme

# Expose port 8080
EXPOSE 8080

# Run echoip
ENTRYPOINT ["/usr/local/bin/echoip"]
