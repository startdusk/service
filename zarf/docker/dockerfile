# Build the Go Binary.
FROM golang:1.18 as build_service
ENV CGO_ENABLED 0
ARG BUILD_REF

# Copy the source code into the container.
COPY . /service

# If you don't have network limitations, comment it out.
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

# Build the ervice binary.
WORKDIR /service
RUN go build -ldflags "-X main.build=${BUILD_REF}"

# Run the Go Binary in Aipine.
FROM alpine:3.16
ARG BUILD_DATE
ARG BUILD_REF
RUN addgroup -g 1000 -S service && \
    adduser -u 1000 -h /service -G service -S service
COPY --from=build_service --chown=service:service /service/service /service/service
WORKDIR /service
USER service
ENTRYPOINT ["./service"]

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="service-api" \
    org.opencontainers.image.authors="startdusk <clylia217@gmail.com>" \
    org.opencontainers.image.source="https://github.com/startdusk/service/app/service-api" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.vendor="startdusk"
