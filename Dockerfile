# Stage 1: Build binary with Go 1.25+
FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build all package entrypoints recursively (or specify ./cmd/...)
RUN CGO_ENABLED=0 GOOS=linux go build -o flan-go-scan ./...

# Stage 2: Minimal runtime image with Nmap & permissions
FROM alpine:latest
RUN apk add --no-cache nmap nmap-scripts ca-certificates

WORKDIR /app
COPY --from=builder /app/flan-go-scan .

# Ensure reports directory exists with write permissions
RUN mkdir -p /app/reports && chmod -R 777 /app/reports

CMD ["./flan-go-scan"]
