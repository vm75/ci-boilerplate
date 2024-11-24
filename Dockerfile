# Use golang:alpine as the base image
FROM golang:alpine

# Enable CGO and install required dependencies
ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=amd64

# Install C compiler and other build tools
RUN apk add --no-cache gcc musl-dev

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Build the application with CGO enabled
RUN go build -o main .

# Run the application
CMD ["./main"]
