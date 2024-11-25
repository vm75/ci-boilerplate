# Stage 1: Build dante sockd and app
FROM golang:alpine AS build

# Install required build tools
RUN apk add --no-cache build-base \
    gcc musl-dev linux-headers \
    libc-dev libc6-compat

# Set the working directory
WORKDIR /workdir

# Set environment variables for cross-compilation
ENV CGO_ENABLED=1

# Copy Go modules files first for caching
COPY go/go.mod go/go.sum /workdir/go/
RUN go mod download -C /workdir/go

# Copy the rest of the application source code
COPY go /workdir/go

# Build the application for multiple architectures
# The build command will later be specified by Buildx
RUN --mount=type=cache,target=/root/.cache/go-build \
    GOOS=linux GOARCH=${TARGETARCH} go build -C /workdir/go -ldflags="-s -w" -o /workdir/app

# Stage 2: Create the final minimal image
FROM alpine:latest AS runtime

# Install required packages
RUN apk --no-cache update
RUN apk --no-cache upgrade

# Copy binaries from build stage
COPY --from=build /workdir/app /opt/app/app

# Create the data directory
RUN mkdir -p /data

# Set the working directory
VOLUME ["/data"]

# Expose ports for app
EXPOSE 8080/tcp

# Healthcheck
HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD netstat -an | grep -c ":::8080 "

# Run app
ENTRYPOINT [ "/opt/app/app" ]
