FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o flan-go-scan .

FROM alpine:latest
RUN apk add --no-cache nmap nmap-scripts ca-certificates

WORKDIR /app
COPY --from=builder /app/flan-go-scan .

# Create reports directory and set full write permissions
RUN mkdir -p /app/reports && chmod -R 777 /app/reports

CMD ["./flan-go-scan"]
