# Build the Go application.
FROM golang:1.23-alpine AS build

WORKDIR /app

# Download dependencies in a separate layer for better build caching.
COPY go.mod go.sum ./
RUN go mod download

COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Run only the compiled application in a small final image.
FROM alpine:3.20

WORKDIR /app
COPY --from=build /app/server .

EXPOSE 8080

CMD ["./server"]
