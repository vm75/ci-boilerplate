# Use golang:alpine as the base image
FROM golang:alpine AS build

# Install required build tools
RUN apk add --no-cache gcc musl-dev

# Set environment variables for cross-compilation
ENV CGO_ENABLED=1

# Set the working directory
WORKDIR /app

# Copy Go modules files first for caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the application for multiple architectures
# The build command will later be specified by Buildx
RUN --mount=type=cache,target=/root/.cache/go-build \
    GOOS=linux GOARCH=${TARGETARCH} go build -o main .

# Use a lightweight image for the final stage
FROM alpine:latest AS runtime

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the build stage
COPY --from=build /app/main .

# Expose port (optional, if your app serves on a specific port)
# EXPOSE 8080

# Run the application
CMD ["./main"]
