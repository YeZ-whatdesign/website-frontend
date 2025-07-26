# Frontend 项目 Linux 部署指南

## 项目概述
几何原本汽车设计公司官网前端，基于Vue 3 + Vite + Element Plus构建的现代化单页应用。

## 系统要求
- Ubuntu 20.04+ / CentOS 8+ / Debian 11+
- Node.js 18.x+
- npm 8.x+
- Nginx (Web服务器)

## 部署步骤

### 1. 系统准备

#### Ubuntu/Debian
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要工具
sudo apt install -y curl wget git build-essential

# 安装Node.js 18.x
curl -fsSL //deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 验证安装
node --version
npm --version
```

#### CentOS/RHEL
```bash
# 更新系统
sudo yum update -y

# 安装必要工具
sudo yum install -y curl wget git gcc-c++ make

# 安装Node.js 18.x
curl -fsSL //rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# 验证安装
node --version
npm --version
```

### 2. 创建部署用户
```bash
# 创建专用用户
sudo useradd -m -s /bin/bash whattech
sudo usermod -aG sudo whattech

# 切换到部署用户
sudo su - whattech
```

### 3. 部署应用

#### 克隆代码
```bash
# 创建应用目录
mkdir -p /home/whattech/apps
cd /home/whattech/apps

# 克隆Frontend项目
git clone //github.com/YeZ-whatdesign/website-frontend.git what-tech-frontend
cd what-tech-frontend
```

#### 安装依赖
```bash
# 安装项目依赖
npm install
```

#### 配置环境变量

创建生产环境配置：
```bash
nano .env.production
```

```env
# API基础URL - 替换为实际的后端API地址
VITE_API_BASE_URL=//api.yourdomain.com

# 应用标题
VITE_APP_TITLE=几何原本汽车设计

# 其他配置
VITE_APP_VERSION=1.0.0
```

#### 构建生产版本
```bash
# 构建应用
npm run build

# 验证构建结果
ls -la dist/
```

### 4. 配置Nginx Web服务器

安装Nginx：
```bash
# Ubuntu/Debian
sudo apt install -y nginx

# CentOS/RHEL
sudo yum install -y nginx
```

创建Nginx配置：
```bash
sudo nano /etc/nginx/sites-available/what-tech-frontend
```

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;  # 替换为实际域名
    root /home/whattech/apps/what-tech-frontend/dist;
    index index.html;

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline' 'unsafe-eval'" always;

    # 日志配置
    access_log /var/log/nginx/what-tech-frontend.access.log;
    error_log /var/log/nginx/what-tech-frontend.error.log;

    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # HTML文件不缓存
    location ~* \.html$ {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
    }

    # Vue Router历史模式支持
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API代理（如果需要）
    location /api/ {
        proxy_pass //api.yourdomain.com;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # 安全配置
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    # 禁止访问敏感文件
    location ~* \.(env|log|htaccess)$ {
        deny all;
        access_log off;
        log_not_found off;
    }
}
```

启用配置：
```bash
# 创建软链接
sudo ln -s /etc/nginx/sites-available/what-tech-frontend /etc/nginx/sites-enabled/

# 删除默认配置（如果存在）
sudo rm -f /etc/nginx/sites-enabled/default

# 测试配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### 5. 配置SSL证书

使用Let's Encrypt免费SSL证书：
```bash
# 安装Certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取SSL证书
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# 设置自动续期
sudo crontab -e
# 添加以下行：
# 0 12 * * * /usr/bin/certbot renew --quiet
```

SSL配置后的Nginx配置会自动更新，包含以下内容：
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;
    root /home/whattech/apps/what-tech-frontend/dist;
    index index.html;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    # SSL优化配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # 其他配置同上...
}

# HTTP重定向到HTTPS
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 //$server_name$request_uri;
}
```

### 6. 设置文件权限

```bash
# 设置正确的文件权限
sudo chown -R whattech:www-data /home/whattech/apps/what-tech-frontend/dist
sudo chmod -R 755 /home/whattech/apps/what-tech-frontend/dist
sudo find /home/whattech/apps/what-tech-frontend/dist -type f -exec chmod 644 {} \;
```

### 7. 防火墙配置

```bash
# Ubuntu/Debian (UFW)
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable

# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 8. 自动化部署脚本

创建部署脚本：
```bash
nano /home/whattech/deploy-frontend.sh
```

```bash
#!/bin/bash

# 前端自动部署脚本
set -e

PROJECT_DIR="/home/whattech/apps/what-tech-website/frontend"
BACKUP_DIR="/home/whattech/backups/frontend"
DATE=$(date +%Y%m%d_%H%M%S)

echo "开始部署前端应用..."

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份当前版本
if [ -d "$PROJECT_DIR/dist" ]; then
    echo "备份当前版本..."
    tar -czf "$BACKUP_DIR/dist_backup_$DATE.tar.gz" -C "$PROJECT_DIR" dist
fi

# 进入项目目录
cd $PROJECT_DIR

# 拉取最新代码
echo "拉取最新代码..."
git pull origin main

# 安装依赖
echo "安装依赖..."
npm ci

# 构建应用
echo "构建应用..."
npm run build

# 设置权限
echo "设置文件权限..."
sudo chown -R whattech:www-data dist
sudo chmod -R 755 dist
sudo find dist -type f -exec chmod 644 {} \;

# 测试Nginx配置
echo "测试Nginx配置..."
sudo nginx -t

# 重新加载Nginx
echo "重新加载Nginx..."
sudo systemctl reload nginx

# 清理旧备份（保留最近5个）
find $BACKUP_DIR -name "dist_backup_*.tar.gz" -mtime +5 -delete

echo "前端部署完成！"
echo "备份文件: $BACKUP_DIR/dist_backup_$DATE.tar.gz"
```

设置执行权限：
```bash
chmod +x /home/whattech/deploy-frontend.sh
```

### 9. 监控和维护

#### 查看访问日志
```bash
# 实时查看访问日志
sudo tail -f /var/log/nginx/what-tech-frontend.access.log

# 查看错误日志
sudo tail -f /var/log/nginx/what-tech-frontend.error.log

# 分析访问统计
sudo cat /var/log/nginx/what-tech-frontend.access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -10
```

#### 性能监控
```bash
# 检查Nginx状态
sudo systemctl status nginx

# 检查磁盘使用
df -h

# 检查内存使用
free -h

# 检查网络连接
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

#### 应用更新
```bash
# 使用部署脚本更新
/home/whattech/deploy-frontend.sh

# 或手动更新
cd /home/whattech/apps/what-tech-frontend
git pull origin main
npm ci
npm run build
sudo systemctl reload nginx
```

## 故障排除

### 常见问题

1. **404错误（Vue Router问题）**
   - 确保Nginx配置中有 `try_files $uri $uri/ /index.html;`
   - 检查文件权限

2. **静态资源加载失败**
```bash
# 检查文件权限
ls -la /home/whattech/apps/what-tech-website/frontend/dist/

# 检查Nginx错误日志
sudo tail -f /var/log/nginx/what-tech-frontend.error.log
```

3. **API请求失败**
   - 检查CORS配置
   - 验证API代理配置
   - 确认后端服务状态

4. **SSL证书问题**
```bash
# 检查证书状态
sudo certbot certificates

# 手动续期
sudo certbot renew --dry-run
```

### 回滚操作

如果部署出现问题，可以快速回滚：
```bash
# 查看备份文件
ls -la /home/whattech/backups/frontend/

# 回滚到指定版本
cd /home/whattech/apps/what-tech-website/frontend
sudo rm -rf dist
sudo tar -xzf /home/whattech/backups/frontend/dist_backup_YYYYMMDD_HHMMSS.tar.gz
sudo chown -R whattech:www-data dist
sudo systemctl reload nginx
```

## 性能优化

### 1. 启用HTTP/2
在SSL配置中添加 `http2`：
```nginx
listen 443 ssl http2;
```

### 2. 配置浏览器缓存
```nginx
# 在server块中添加
location ~* \.(js|css)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header Vary "Accept-Encoding";
}
```

### 3. 启用Brotli压缩（可选）
```bash
# 安装Brotli模块
sudo apt install nginx-module-brotli

# 在nginx.conf中添加
load_module modules/ngx_http_brotli_filter_module.so;
load_module modules/ngx_http_brotli_static_module.so;

# 在http块中添加
brotli on;
brotli_comp_level 6;
brotli_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
```

### 4. CDN集成
考虑使用CDN来加速静态资源加载：
- 阿里云CDN
- 腾讯云CDN
- CloudFlare

## 安全建议

1. 定期更新系统和Nginx
2. 配置Web应用防火墙(WAF)
3. 使用强SSL配置
4. 定期备份网站文件
5. 监控访问日志，识别异常访问
6. 配置rate limiting防止DDoS攻击

```nginx
# 在server块中添加rate limiting
limit_req_zone $binary_remote_addr zone=frontend:10m rate=10r/s;
limit_req zone=frontend burst=20 nodelay;
```