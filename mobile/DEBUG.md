# 调试指南

## 查看错误日志的方法

### Android

1. **使用 logcat 查看日志**:
```bash
# 查看所有日志
adb logcat

# 只查看 React Native 相关日志
adb logcat *:S ReactNative:V ReactNativeJS:V

# 查看错误日志
adb logcat | grep -i error
```

2. **使用 Metro 日志**:
```bash
npm start
# Metro 会在终端显示 JavaScript 错误
```

3. **在 Android Studio 中查看**:
   - 打开 Android Studio
   - 运行应用
   - 查看 Logcat 窗口

### iOS

1. **使用 Xcode 控制台**:
   - 在 Xcode 中运行应用
   - 查看底部控制台输出

2. **使用终端查看系统日志**:
```bash
# 查看设备日志
xcrun simctl spawn booted log stream --level=debug

# 或者使用 Console.app
```

3. **使用 Metro 日志**:
```bash
npm start
# Metro 会在终端显示 JavaScript 错误
```

## 常见问题排查

### 1. 应用启动即崩溃

**可能原因**:
- 缺少原生模块初始化
- 导入路径错误
- NativeWind 配置问题

**解决方法**:
1. 检查 `index.js` 是否正确导入了 `react-native-gesture-handler`
2. 检查 `babel.config.js` 配置
3. 清除缓存重新构建:
```bash
# Android
cd android && ./gradlew clean && cd ..
npm start -- --reset-cache
npm run android

# iOS
cd ios && pod install && cd ..
npm start -- --reset-cache
npm run ios
```

### 2. 网络请求失败

**可能原因**:
- API 地址配置错误
- Android 模拟器网络配置问题
- 真机网络权限问题

**解决方法**:
1. 检查 `src/utils/config.ts` 中的 API_BASE_URL
2. Android 模拟器使用 `10.0.2.2` 而不是 `localhost`
3. 真机需要配置实际 IP 地址

### 3. Navigation 相关错误

**可能原因**:
- react-native-screens 未正确初始化
- react-native-gesture-handler 未正确导入

**解决方法**:
1. 确保 `index.js` 顶部导入了 `react-native-gesture-handler`
2. 确保启用了 `react-native-screens`

### 4. NativeWind 样式不生效

**可能原因**:
- tailwind.config.js 配置错误
- Metro 缓存问题

**解决方法**:
1. 检查 `tailwind.config.js` 的 content 路径
2. 清除 Metro 缓存: `npm start -- --reset-cache`

## 调试技巧

1. **添加 console.log**:
```javascript
console.log('[组件名] 调试信息:', data);
```

2. **使用 React Native Debugger**:
   - 安装 React Native Debugger
   - 在应用中摇动设备，选择 "Debug"

3. **使用 Flipper**:
   - 安装 Flipper
   - 连接设备后自动显示日志

4. **检查错误边界**:
   - 应用已添加 ErrorBoundary
   - 如果崩溃，会显示错误信息界面

## 快速修复命令

```bash
# 完全清理并重新构建
cd mobile
rm -rf node_modules
npm install
cd android && ./gradlew clean && cd ..
cd ios && pod install && cd ..
npm start -- --reset-cache
```

