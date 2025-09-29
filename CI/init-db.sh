#!/bin/bash

echo "=========================================="
echo " 数据库初始化脚本启动"
echo "=========================================="

# 从连接字符串中解析数据库连接信息
# 格式: Host=postgres;Port=5432;Database=letu;User ID=postgres;Password=postgres123;
CONNECTION_STRING="${ConnectionStrings__Default}"

if [ -z "$CONNECTION_STRING" ]; then
    echo "错误：未设置数据库连接字符串 (ConnectionStrings__Default)"
    echo "请在环境变量或 docker-compose.yml 中配置"
    exit 1
fi

echo "连接字符串: $CONNECTION_STRING"

# 解析连接字符串（兼容不同的键名格式）
DB_HOST=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Hh]ost=\([^;]*\).*/\1/p')
DB_PORT=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Pp]ort=\([^;]*\).*/\1/p')
DB_NAME=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Dd]atabase=\([^;]*\).*/\1/p')
DB_USER=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Uu]ser [Ii][Dd]=\([^;]*\).*/\1/p')
if [ -z "$DB_USER" ]; then
    DB_USER=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Uu]sername=\([^;]*\).*/\1/p')
fi
DB_PASSWORD=$(echo "$CONNECTION_STRING" | sed -n 's/.*[Pp]assword=\([^;]*\).*/\1/p')

# 设置默认端口
if [ -z "$DB_PORT" ]; then
    DB_PORT="5432"
fi

echo "数据库连接信息："
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: [已隐藏]"

# 验证必要参数
if [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "错误：无法从连接字符串解析完整的数据库连接信息"
    echo "请检查连接字符串格式是否正确"
    exit 1
fi

# 等待 PostgreSQL 启动
echo ""
echo "等待数据库服务就绪..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; then
        echo "✓ 数据库服务已就绪"
        break
    fi

    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "  尝试 $RETRY_COUNT/$MAX_RETRIES - 数据库尚未就绪，等待 3 秒..."
    sleep 3
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "错误：无法连接到数据库服务"
    echo "请检查："
    echo "  1. PostgreSQL 容器是否正在运行"
    echo "  2. 网络配置是否正确"
    echo "  3. 数据库凭据是否正确"
    exit 1
fi

# 检查是否已经初始化
echo ""
echo "检查数据库初始化状态..."
TABLE_EXISTS=$(PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'sys_user')" 2>/dev/null)

if [ "$TABLE_EXISTS" = "t" ]; then
    echo "✓ 数据库已初始化，跳过初始化步骤"
else
    echo "数据库未初始化，开始执行初始化脚本..."

    # 检查初始化脚本是否存在
    if [ ! -f "/app/dbscripts/table_struct_data.sql" ]; then
        echo "错误：初始化脚本不存在 (/app/dbscripts/table_struct_data.sql)"
        echo "请确保构建镜像时已包含数据库初始化脚本"
        exit 1
    fi

    # 执行初始化脚本
    echo "正在执行: /app/dbscripts/table_struct_data.sql"
    PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f /app/dbscripts/table_struct_data.sql

    if [ $? -eq 0 ]; then
        echo "✓ 数据库初始化成功！"

        # 验证初始化结果
        TABLE_COUNT=$(PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public'" 2>/dev/null)
        echo "  已创建 $TABLE_COUNT 个表"
    else
        echo "✗ 数据库初始化失败！"
        echo "请检查："
        echo "  1. SQL 脚本是否有语法错误"
        echo "  2. 数据库用户是否有创建表的权限"
        echo "  3. 查看上面的错误信息获取详细信息"
        exit 1
    fi
fi

# 启动应用
echo ""
echo "=========================================="
echo " 启动 .NET 应用"
echo "=========================================="
exec "$@"