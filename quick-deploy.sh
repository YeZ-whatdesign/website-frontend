#!/bin/bash

# What-Tech 网站快速部署脚本
# 适用于 Ubuntu 20.04+ / Debian 11+

set -e

echo "=== What-Tech 网站快速部署脚本 ==="
echo "开始时间: $(date)"
echo

# 检查是否为root用户
if [ "$EUID" -eq 0 ]; then
    echo "请不要使用root用户运行此脚本"
    exit 1
fi

# 1. 系统初始化
echo "1. 更新系统包..."
sudo apt update && sudo apt upgrade -y

echo "2. 安装基础软件..."
sudo apt install -y curl wget git nginx build-essential

# 3. 安装Node.js
echo "3. 安装Node.js 20 (NodeBB v4.4.4推荐版本)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 验证Node.js版本
echo "Node.js版本: $(node --version)"
echo "npm版本: $(npm --version)"

# 4. 安装PM2
echo "4. 安装PM2..."
sudo npm install -g pm2

# 5. 安装MongoDB
echo "5. 安装MongoDB..."

# 检测Ubuntu版本
UBUNTU_VERSION=$(lsb_release -cs)
echo "检测到Ubuntu版本: $UBUNTU_VERSION"

# 清理之前的配置
sudo rm -f /etc/apt/sources.list.d/mongodb-org-*.list

# 安装必要的依赖
sudo apt update
sudo apt install -y wget curl gnupg2 software-properties-common apt-transport-https ca-certificates

# 方法1: 尝试安装MongoDB 7.0 (推荐)
echo "尝试安装MongoDB 7.0..."
# 清理之前的配置
sudo rm -f /etc/apt/sources.list.d/mongodb-org-*.list

# 安装必要的依赖
sudo apt update
sudo apt install -y wget curl gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release

# 添加MongoDB GPG密钥
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

# 添加MongoDB仓库（适用于Ubuntu 22.04）
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# 更新包列表
sudo apt update

# 彻底卸载和删除mongodb
echo "彻底卸载和删除mongodb..."
sudo apt remove -y mongodb-org
sudo apt autoremove -y
sudo apt autoclean -y
sudo rm -rf /var/lib/mongodb
sudo rm -rf /var/log/mongodb
sudo rm -rf /etc/mongod.conf

# 安装MongoDB
sudo apt install -y mongodb-org

# 启动MongoDB服务
sudo systemctl start mongod
sudo systemctl enable mongod

# 等待MongoDB启动
sleep 5

# 配置MongoDB用户和数据库
echo "配置MongoDB数据库和用户..."
mongosh --eval "
use admin

db.createUser({
  user: 'admin',
  pwd: 'admin123',
  roles: [{ role: 'root', db: 'admin' }]
})

use nodebb

db.createUser({
  user: 'nodebb',
  pwd: 'nodebb123',
  roles: [
    { role: 'readWrite', db: 'nodebb' },
    { role: 'clusterMonitor', db: 'admin' }
  ]
})
"

# 启用MongoDB认证
echo "启用MongoDB认证..."
sudo tee -a /etc/mongod.conf > /dev/null << EOF

# 启用认证
security:
  authorization: enabled
EOF

# 重启MongoDB服务
sudo systemctl restart mongod
echo "✓ MongoDB配置完成"
echo "⚠️  请记住更改默认密码："
echo "   - 管理员密码: admin123"
echo "   - NodeBB用户密码: nodebb123"

mongosh --eval "
use admin
db.auth('admin', { pwd: 'admin123' })
use nodebb
db.auth('nodebb', { pwd: 'nodebb123' })
"

# 6. 创建目录结构
echo "6. 创建目录结构..."
mkdir -p /home/$(whoami)/{apps,backups,logs,scripts}

# 7. 复制项目到部署目录
echo "7. 复制项目到部署目录..."
cd /home/$(whoami)/apps

# 复制Backend项目
if [ ! -d "website-backend" ]; then
    echo "复制Backend项目..."
    # 假设脚本从项目根目录运行
    if [ -d "/root/what-tech/website/website-backend" ]; then
        cp -r /root/what-tech/website/website-backend ./
        echo "✓ Backend项目复制完成"
    elif [ -d "$(dirname $(pwd))/website-backend" ]; then
        cp -r "$(dirname $(pwd))/website-backend" ./
        echo "✓ Backend项目复制完成"
    else
        echo "⚠️  Backend项目源目录未找到，请手动复制"
    fi
else
    echo "✓ Backend项目已存在"
fi

# 复制Frontend项目
if [ ! -d "website-frontend" ]; then
    echo "复制Frontend项目..."
    if [ -d "/root/what-tech/website/website-frontend" ]; then
        cp -r /root/what-tech/website/website-frontend ./
        echo "✓ Frontend项目复制完成"
    elif [ -d "$(dirname $(pwd))/website-frontend" ]; then
        cp -r "$(dirname $(pwd))/website-frontend" ./
        echo "✓ Frontend项目复制完成"
    else
        echo "⚠️  Frontend项目源目录未找到，请手动复制"
    fi
else
    echo "✓ Frontend项目已存在"
fi

# 复制NodeBB项目
if [ ! -d "NodeBB" ]; then
    echo "复制NodeBB项目..."
    if [ -d "/root/what-tech/website/NodeBB" ]; then
        cp -r /root/what-tech/website/NodeBB ./
        echo "✓ NodeBB项目复制完成"
    elif [ -d "$(dirname $(pwd))/NodeBB" ]; then
        cp -r "$(dirname $(pwd))/NodeBB" ./
        echo "✓ NodeBB项目复制完成"
    else
        echo "⚠️  NodeBB项目源目录未找到，请手动复制"
    fi
else
    echo "✓ NodeBB项目已存在"
fi

# 8. 部署Backend
echo "8. 部署Backend..."
if [ -d "website-backend" ]; then
    cd website-backend
    if [ -f "package.json" ]; then
        npm install --production
        if [ ! -f ".env" ]; then
            cp .env.example .env 2>/dev/null || echo "请手动创建.env文件"
        fi
        echo "✓ Backend部署完成"
    else
        echo "⚠️  Backend目录中未找到package.json文件"
    fi
    cd ..
else
    echo "⚠️  Backend目录不存在，跳过部署"
fi

# 9. 部署Frontend
echo "9. 部署Frontend..."
if [ -d "website-frontend" ]; then
    cd website-frontend
    if [ -f "package.json" ]; then
        npm install
        npm run build
        echo "✓ Frontend构建完成"
    else
        echo "⚠️  Frontend目录中未找到package.json文件"
    fi
    cd ..
else
    echo "⚠️  Frontend目录不存在，跳过部署"
fi

# 10. 部署NodeBB
echo "10. 部署NodeBB..."
if [ -d "NodeBB" ]; then
    cd NodeBB
    if [ -f "package.json" ]; then
        echo "安装NodeBB依赖..."
        npm install --omit=dev
        echo "✓ NodeBB依赖安装完成"
        
        echo "配置NodeBB数据库连接..."
        # 创建NodeBB配置文件
        cat > config.json << EOF
{
    "url": "http://www.what-tech.cn/forum",
    "secret": "$(openssl rand -hex 32)",
    "database": "mongo",
    "mongo": {
        "host": "127.0.0.1",
        "port": "27017",
        "username": "nodebb",
        "password": "nodebb123",
        "database": "nodebb",
        "uri": ""
    },
    "port": "4567",
    "defaultLang": "zh-CN",
    "locale": "zh-CN"
}
EOF
        
        echo "✓ NodeBB配置文件已创建"
        
        # 构建NodeBB资源
        echo "构建NodeBB资源..."
        ./nodebb build
        echo "✓ NodeBB资源构建完成"
        
        # 自动化设置NodeBB
        echo "开始NodeBB自动化设置..."
        
        # 设置环境变量进行自动化安装
        export admin__username="admin"
        export admin__password="admin123"
        export admin__password__confirm="admin123"
        export admin__email="admin@what-tech.cn"
        export database="mongo"
        export mongo__host="127.0.0.1"
        export mongo__port="27017"
        export mongo__username="nodebb"
        export mongo__password="nodebb123"
        export mongo__database="nodebb"
        export url="http://www.what-tech.cn/forum"
        export port="4567"
        export defaultLang="zh-CN"
        
        # 运行NodeBB设置
        echo "运行NodeBB自动化设置..."
        ./nodebb setup || {
            echo "⚠️  自动化设置失败，请手动运行设置："
            echo "   cd /home/$(whoami)/apps/NodeBB"
            echo "   ./nodebb setup"
            echo "   管理员账户: admin / admin123456"
            echo "   邮箱: admin@what-tech.cn"
        }
        
        echo "✓ NodeBB设置完成"
        
    else
        echo "⚠️  NodeBB目录中未找到package.json文件"
    fi
    cd ..
else
    echo "⚠️  NodeBB目录不存在，跳过部署"
fi

# 11. 创建PM2配置
echo "11. 创建PM2配置..."
cd /home/$(whoami)/apps
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'website-backend',
      script: 'server.js',
      cwd: '/home/whattech/apps/website-backend',
      instances: 2,
      exec_mode: 'cluster',
      env_production: {
        NODE_ENV: 'production',
        PORT: 3001
      },
      log_file: '/home/whattech/logs/backend-combined.log',
      out_file: '/home/whattech/logs/backend-out.log',
      error_file: '/home/whattech/logs/backend-error.log',
      max_memory_restart: '1G'
    },
    {
      name: 'nodebb',
      script: 'loader.js',
      cwd: '/home/whattech/apps/NodeBB',
      instances: 1,
      exec_mode: 'fork',
      env_production: {
        NODE_ENV: 'production',
        PORT: 4567
      },
      log_file: '/home/whattech/logs/nodebb-combined.log',
      out_file: '/home/whattech/logs/nodebb-out.log',
      error_file: '/home/whattech/logs/nodebb-error.log',
      max_memory_restart: '2G'
    }
  ]
};
EOF

# 替换用户名
sed -i "s/whattech/$(whoami)/g" ecosystem.config.js
echo "✓ PM2配置创建完成"

# 12. 配置Nginx
echo "12. 配置Nginx..."
sudo tee /etc/nginx/sites-available/what-tech-website > /dev/null << EOF
# Frontend - 主网站
server {
    listen 80;
    server_name what-tech.cn www.what-tech.cn localhost;
    root /home/root/apps/website-frontend/dist;
    index index.html;

    # Gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # 上传文件代理到Backend (必须在静态资源规则之前)
    location /uploads/ {
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # API代理到Backend
    location /api/ {
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # 静态资源缓存 (排除uploads路径)
    location ~* ^(?!/uploads/).*\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # NodeBB Forum 代理
    location /forum/ {
        proxy_pass http://127.0.0.1:4567/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 处理NodeBB的相对路径
        proxy_redirect / /forum/;
        proxy_redirect http://\$host/ http://\$host/forum/;
    }

    # Vue Router支持 (放在最后)
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# 启用Nginx配置
sudo ln -sf /etc/nginx/sites-available/what-tech-website /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
echo "✓ Nginx配置完成"

# 13. 创建管理脚本
echo "13. 创建管理脚本..."
cat > /home/$(whoami)/scripts/start-all.sh << 'EOF'
#!/bin/bash
echo "启动所有服务..."
cd /home/$(whoami)/apps
pm2 start ecosystem.config.js --env production
pm2 save
echo "所有服务已启动"
EOF

cat > /home/$(whoami)/scripts/stop-all.sh << 'EOF'
#!/bin/bash
echo "停止所有服务..."
pm2 stop all
echo "所有服务已停止"
EOF

cat > /home/$(whoami)/scripts/status.sh << 'EOF'
#!/bin/bash
echo "=== 服务状态 ==="
pm2 status
echo
echo "=== 端口监听 ==="
netstat -tuln | grep -E ":(3001|4567|80|8080)"
EOF

chmod +x /home/$(whoami)/scripts/*.sh
echo "✓ 管理脚本创建完成"

echo
echo "=== 部署完成 ==="
echo "✓ 系统环境已配置"
echo "✓ Node.js 20已安装"
echo "✓ MongoDB已安装并配置用户"
echo "✓ 项目代码已复制"
echo "✓ 依赖包已安装"
echo "✓ NodeBB已自动化设置"
echo "✓ Nginx已配置"
echo "✓ 管理脚本已创建"
echo
echo "🔐 默认账户信息："
echo "- MongoDB管理员: admin / admin123"
echo "- MongoDB NodeBB用户: nodebb / nodebb123"
echo "- NodeBB管理员: admin / admin123456"
echo "- NodeBB管理员邮箱: admin@what-tech.cn"
echo "⚠️  请立即更改这些默认密码！"
echo
echo "🚀 NodeBB已自动配置完成："
echo "- 默认语言: 中文 (zh-CN)"
echo "- 管理员账户已创建"
echo "- 数据库连接已配置"
echo "- 如果自动设置失败，请手动运行:"
echo "  cd /home/$(whoami)/apps/NodeBB && ./nodebb setup"
echo
echo "下一步操作："
echo "1. 配置Backend环境变量: nano /home/$(whoami)/apps/website-backend/.env"
echo "2. 完成NodeBB配置（见上方步骤）"
echo "3. 启动服务: /home/$(whoami)/scripts/start-all.sh"
echo "4. 检查状态: /home/$(whoami)/scripts/status.sh"
echo
echo "访问地址："
echo "🌐 生产环境："
echo "- 主网站: http://www.what-tech.cn:8081"
echo "- NodeBB论坛: http://www.what-tech.cn/forum"
echo "- Backend API: http://www.what-tech.cn:3001/api"
echo
echo "🔧 本地测试："
echo "- 主网站: http://localhost:8082"
echo "- NodeBB论坛: http://localhost:8082/forum"
echo "- Backend API: http://localhost:3001"
echo "- Apache2 (如果运行): http://localhost:80"
echo
echo "⚠️  重要配置："
echo "- 确保域名 www.what-tech.cn 已解析到此服务器"
echo "- NodeBB现在通过 /forum 路径访问，不再需要单独的子域名"
echo "- 由于Apache2占用80端口，网站使用8081端口"
echo "- 如需使用80端口，请停止Apache2: sudo systemctl stop apache2"
echo "- 建议配置SSL证书后使用HTTPS"
echo
echo "项目目录结构："
echo "- Backend: /home/$(whoami)/apps/website-backend"
echo "- Frontend: /home/$(whoami)/apps/website-frontend"
echo "- NodeBB: /home/$(whoami)/apps/NodeBB"
echo
echo "日志文件位置："
echo "- Backend: /home/$(whoami)/logs/backend-*.log"
echo "- NodeBB: /home/$(whoami)/logs/nodebb-*.log"
echo
echo "完成时间: $(date)"