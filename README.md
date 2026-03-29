# web

## Docker Web Environment

当前项目使用单容器方式运行：

- 容器内运行 `nginx`
- 容器内运行 `php8-fpm`

目录约定：

- 网站根目录：`www/`
- SSL 证书目录：`www/ssl/`

证书文件名：

- `www/ssl/fullchain.pem`
- `www/ssl/privkey.pem`

### 构建镜像

在项目根目录执行：

```bash
docker build -t xxx/web:latest -f docker/php/Dockerfile .
```

### 启动容器

如果你要映射本地 `/opt/www`：

```bash
docker run -d \
  --name web \
  -p 80:80 \
  -p 443:443 \
  --restart always \
  -v /opt/www:/var/www/html \
  xxx/web:latest
```

如果你直接使用当前项目里的 `www` 目录：

```bash
docker run -d \
  --name web \
  -p 80:80 \
  -p 443:443 \
  --restart always \
  -v "$PWD/www:/var/www/html" \
  xxx/web:latest
```

### 停止容器

```bash
docker rm -f web
```

### 说明

- HTTP 会自动跳转到 HTTPS
- nginx 会拒绝外部访问 `ssl` 目录
- 启动前请先准备好证书文件

## GitHub Actions

项目已加入 GitHub Actions 工作流：

- 自动触发：`push`
- 手动触发：`workflow_dispatch`

工作流文件：

- `.github/workflows/docker-build.yml`

Actions 只做一件事：

- 构建 Docker 镜像并推送到 GHCR

推送标签：

- `ghcr.io/<你的 GitHub 用户名或组织名>/web:latest`
- `ghcr.io/<你的 GitHub 用户名或组织名>/web:<branch>`
- `ghcr.io/<你的 GitHub 用户名或组织名>/web:sha-<commit>`

推送依赖 GitHub Actions 自带的 `GITHUB_TOKEN`。如果你的仓库或组织限制了包写入权限，需要确保 Actions 允许写入 Packages。
