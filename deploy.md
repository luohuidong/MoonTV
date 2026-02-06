# 部署：使用 PM2 管理 Next.js 应用

此文档说明如何使用 PM2 和 `pnpm` 部署本项目。已提供 `ecosystem.config.js`，可直接用于启动。

前提

- 已安装 `pnpm` 和 `pm2`（服务器上）：

```bash
npm install -g pnpm pm2
# 或使用 pnpm 自身安装 pm2
pnpm add -g pm2
```

快速开始（首次部署）

```bash
# 拉取代码并安装依赖
git pull
pnpm install --frozen-lockfile

# 构建
pnpm build

# 使用 PM2 启动（使用仓库根目录的 ecosystem.config.js）
pm2 start ecosystem.config.js --env production

# 保存当前进程列表（开机自启需要先执行 pm2 startup）
pm2 save
```

常用命令

- 重新加载（零停机）：

```bash
pm2 reload ecosystem.config.js --env production
```

- 重新启动单个应用：

```bash
pm2 restart moontv
```

- 停止/删除：

```bash
pm2 stop moontv
pm2 delete moontv
```

- 查看日志：

```bash
pm2 logs moontv
```

- 查看状态：

```bash
pm2 status
```

设置开机自启（systemd 示例）

```bash
# 该命令会输出一条需要以 root 执行的命令，按提示执行
pm2 startup systemd
pm2 save
```

注意事项

- `ecosystem.config.js` 已设置为使用 `pnpm start` 启动（见 [ecosystem.config.js](ecosystem.config.js)）。确保服务器 PATH 中能找到 `pnpm`，或者将 `script` 改为 `node` 并给出完整入口。
- 如果需要在部署脚本中自动构建并重载，可使用：

```bash
git pull
pnpm install --frozen-lockfile
pnpm build
pm2 reload ecosystem.config.js --env production
```

示例完整部署脚本（可保存为 `deploy.sh` 并在服务器上运行）：

```bash
#!/usr/bin/env bash
set -e

git pull
pnpm install --frozen-lockfile
pnpm build
pm2 reload ecosystem.config.js --env production || pm2 start ecosystem.config.js --env production
pm2 save
```
