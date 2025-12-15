# LZC Mock OIDC

一个轻量级的 OpenID Connect (OIDC) Mock 服务器，用于本地开发和测试。

## 特性

- ✅ 完整的 OIDC 流程支持（Authorization Code Flow）
- ✅ 轻量级，基于 Go + Gin
- ✅ 兼容性好，无 CPU 架构限制
- ✅ 自动批准所有授权请求
- ✅ 支持环境变量配置
- ✅ Docker 支持

## 快速开始

### 使用 Docker

```bash
# 构建镜像
docker build -t lzc-mock-oidc:latest .

# 运行容器
docker run -d \
  --name lzc-oidc-mock \
  -p 8080:8080 \
  -e OIDC_CLIENT_ID=test-client \
  -e OIDC_CLIENT_SECRET=test-secret \
  lzc-mock-oidc:latest
```

### 本地运行

```bash
# 安装依赖
go mod download

# 运行
go run cmd/oidc-mock/main.go
```

## 环境变量

- `OIDC_PORT` - 服务端口（默认: 8080）
- `OIDC_ISSUER` - Issuer URL（默认: http://localhost:8080）
- `OIDC_CLIENT_ID` - 客户端 ID（默认: test-client）
- `OIDC_CLIENT_SECRET` - 客户端密钥（默认: test-secret）

## API 端点

- `GET /.well-known/openid-configuration` - OIDC 配置发现
- `GET /authorize` - 授权端点
- `POST /token` - Token 交换端点
- `GET /userinfo` - 用户信息端点
- `POST /userinfo` - 用户信息端点（支持 POST）
- `GET /health` - 健康检查

## 使用示例

### 配置客户端应用

```bash
export LAZYCAT_AUTH_OIDC_CLIENT_ID=test-client
export LAZYCAT_AUTH_OIDC_CLIENT_SECRET=test-secret
export LAZYCAT_AUTH_OIDC_AUTH_URI=http://localhost:8080/authorize
export LAZYCAT_AUTH_OIDC_TOKEN_URI=http://localhost:8080/token
export LAZYCAT_AUTH_OIDC_USERINFO_URI=http://localhost:8080/userinfo
```

### 测试授权流程

```bash
# 1. 获取授权码（会自动重定向）
curl -L "http://localhost:8080/authorize?response_type=code&client_id=test-client&redirect_uri=http://localhost:8071/auth/oidc/callback&state=test123"

# 2. 使用授权码换取 token
curl -X POST http://localhost:8080/token \
  -d "grant_type=authorization_code" \
  -d "code=<authorization_code>" \
  -d "client_id=test-client" \
  -d "client_secret=test-secret"

# 3. 使用 access token 获取用户信息
curl http://localhost:8080/userinfo \
  -H "Authorization: Bearer <access_token>"
```

## 许可证

Apache License 2.0

