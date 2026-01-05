# React Native 应用

这是一个 React Native 项目。

## 如何启动应用

### 1. 安装依赖

```sh
npm install
```

### 2. 启动 Metro 服务器

在一个终端窗口中运行：

```sh
npm start
```

### 3. 运行应用

在另一个终端窗口中，根据你的平台选择：

**Android：**
```sh
npm run android
```

**iOS：**
```sh
npm run ios
```

应用将在模拟器或连接的设备上启动。

## 开发

### 重命名应用名称

```sh
npx react-native-rename "Travel App" -b "com.junedomingo.travelapp"
```

## 注意事项

- 确保已按照 [React Native 环境设置指南](https://reactnative.dev/docs/set-up-your-environment) 完成环境配置
- 首次运行 iOS 应用时，需要先安装 CocoaPods 依赖（在 `ios` 目录下运行 `pod install`）
