FROM golang:1.27.3-alpine AS builder

WORKDIR /build

# 复制 go.mod 和 go.sum（如果存在）
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY cmd/oidc-mock ./cmd/oidc-mock

# 构建
RUN CGO_ENABLED=0 GOOS=linux go build -o oidc-mock ./cmd/oidc-mock

# 最终镜像
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /build/oidc-mock .

EXPOSE 8080

CMD ["./oidc-mock"]

