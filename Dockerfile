# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o flan-go-scan .

# Stage 2: Minimal runtime image with Nmap
FROM alpine:latest
RUN apk add --no-cache nmap nmap-scripts ca-certificates
WORKDIR /app
COPY --from=builder /app/flan-go-scan .

CMD ["./flan-go-scan"]
