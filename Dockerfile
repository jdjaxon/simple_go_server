# Separate stage for building
FROM golang:1.23-bullseye AS builder

WORKDIR /app

RUN useradd -u 1001 nonroot

COPY . .

RUN go build \
    -ldflags="-linkmode external -extldflags -static" \
    -o simple_go_server


# Separate stage for deployable image
FROM scratch

WORKDIR /

COPY --from=builder /etc/passwd /etc/passwd

COPY --from=builder /app/simple_go_server simple_go_server

USER nonroot

EXPOSE 8080

CMD ["/simple_go_server"]
