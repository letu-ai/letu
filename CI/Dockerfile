# 使用 .NET 9 运行时基础镜像
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# 配置清华源镜像并安装 PostgreSQL 客户端工具
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 从临时构建目录复制所有文件（包含后端、前端和数据库初始化文件）
COPY temp/build/app/ .

# 设置脚本执行权限（检查文件是否存在）
RUN if [ -f /app/init-db.sh ]; then \
        sed -i 's/\r$//' /app/init-db.sh; \
        chmod +x /app/init-db.sh; \
        echo "init-db.sh 权限设置成功"; \
    else \
        echo "错误：init-db.sh 文件不存在"; \
        ls -la /app/ | head -10; \
        exit 1; \
    fi

# 设置环境变量
ENV ASPNETCORE_ENVIRONMENT=Docker
ENV DOTNET_RUNNING_IN_CONTAINER=true

# 暴露端口
EXPOSE 80

# 使用初始化脚本作为入口点
ENTRYPOINT ["/app/init-db.sh"]
CMD ["dotnet", "Letu.Server.dll"]