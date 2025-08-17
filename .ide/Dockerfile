# 使用 .NET SDK 9.0 基础镜像
FROM mcr.microsoft.com/dotnet/sdk:9.0

# 安装 Node.js 22.x（最新稳定版）
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    # 清理缓存以减小镜像体积
    && rm -rf /var/lib/apt/lists/* \
    # 验证安装
    && node -v \
    && npm -v

# 配置 npm 淘宝镜像源（加速国内依赖下载）
RUN npm config set registry https://registry.npmmirror.com

# 安装 code-server 和 vscode 常用插件
RUN curl -fsSL https://code-server.dev/install.sh | sh \
  && code-server --install-extension cnbcool.cnb-welcome \
  && code-server --install-extension redhat.vscode-yaml \
  && code-server --install-extension dbaeumer.vscode-eslint \
  && code-server --install-extension waderyan.gitblame \
  && code-server --install-extension mhutchie.git-graph \
  && code-server --install-extension donjayamanne.githistory \
  && code-server --install-extension tencent-cloud.coding-copilot \
  && code-server --install-extension muhammad-sammy.csharp \
  && code-server --install-extension bradlc.vscode-tailwindcss \
  && echo done

# 安装 ssh 服务，用于支持 VSCode 等客户端通过 Remote-SSH 访问开发环境（也可按需安装其他软件）
RUN apt-get update && apt-get install -y git wget unzip openssh-server

RUN dotnet dev-certs https --trust  \
  && npm install -g pnpm

# 指定字符集支持命令行输入中文（根据需要选择字符集）
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8