# Stage 1: Hermetic source build
FROM golang:1.26-alpine AS build

LABEL maintainer="Luis Corzo <lgcorzo@phdata.internal>"

WORKDIR /build

RUN apk add --no-cache ca-certificates git make bash

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source tree and compile
COPY . .

ARG TARGETOS TARGETARCH
ENV CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}

RUN go build -v -trimpath -ldflags="-s -w" -o /go/bin/mc .

# Stage 2: Minimal sovereign runtime image
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

COPY --from=build /go/bin/mc /usr/bin/mc
COPY CREDITS /licenses/CREDITS
COPY LICENSE /licenses/LICENSE

USER 10001:10001

ENTRYPOINT ["mc"]
