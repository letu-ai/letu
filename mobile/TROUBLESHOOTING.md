# 故障排查指南

## 应用启动即崩溃的排查步骤

### 步骤 1: 查看错误日志

**Android**:
```bash
# 方法 1: 使用 adb logcat
adb logcat | grep -i "error\|exception\|fatal"

# 方法 2: 查看 Metro 日志
npm start
# 在另一个终端运行
npm run android
```

**iOS**:
```bash
# 在 Xcode 中运行应用，查看控制台输出
# 或使用终端
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "demo01"'
```

### 步骤 2: 使用测试应用

如果主应用无法启动，可以临时使用测试应用：

1. 备份 `App.tsx`:
```bash
cp App.tsx App.tsx.backup
```

2. 使用测试应用:
```bash
cp App.test.tsx App.tsx
```

3. 重新运行:
```bash
npm start -- --reset-cache
npm run android  # 或 npm run ios
```

如果测试应用能正常启动，说明问题在主应用的代码中。

### 步骤 3: 逐步添加功能

如果测试应用能启动，逐步恢复功能：

1. **先测试基础导航**:
   - 只导入 `RootNavigator`
   - 不导入其他复杂组件

2. **测试状态管理**:
   - 添加 `authStore`
   - 检查是否有异步初始化问题

3. **测试 API 调用**:
   - 添加 `httpClient`
   - 检查网络配置

### 步骤 4: 常见问题修复

#### 问题 1: react-native-screens 未初始化

**症状**: 导航相关错误

**解决**:
确保 `index.js` 中有:
```javascript
import { enableScreens } from 'react-native-screens';
enableScreens();
```

#### 问题 2: react-native-gesture-handler 未正确导入

**症状**: 手势相关错误

**解决**:
确保 `index.js` 最顶部有:
```javascript
import 'react-native-gesture-handler';
```

#### 问题 3: NativeWind 配置问题

**症状**: 样式不生效或编译错误

**解决**:
1. 检查 `babel.config.js`:
```javascript
presets: ['module:@react-native/babel-preset', 'nativewind/babel']
```

2. 检查 `tailwind.config.js` content 路径

3. 清除缓存:
```bash
npm start -- --reset-cache
```

#### 问题 4: AsyncStorage 初始化问题

**症状**: 存储相关错误

**解决**:
检查 `src/utils/storage.ts` 中的 AsyncStorage 导入是否正确

#### 问题 5: 循环依赖

**症状**: 模块加载错误

**解决**:
检查导入路径，避免循环依赖

### 步骤 5: 完全清理重建

如果以上方法都不行，尝试完全清理：

```bash
# 1. 清理 node_modules
rm -rf node_modules
rm package-lock.json

# 2. 清理 Android 构建
cd android
./gradlew clean
rm -rf .gradle
cd ..

# 3. 清理 iOS 构建（如果使用 iOS）
cd ios
rm -rf Pods Podfile.lock build
pod deintegrate
pod install
cd ..

# 4. 清理 Metro 缓存
rm -rf $TMPDIR/react-*

# 5. 重新安装
npm install

# 6. 重新运行
npm start -- --reset-cache
npm run android  # 或 npm run ios
```

### 步骤 6: 检查原生配置

**Android**:
1. 检查 `android/app/build.gradle` 中的依赖版本
2. 检查 `AndroidManifest.xml` 中的权限配置
3. 确保 `MainActivity.kt` 正确配置

**iOS**:
1. 检查 `Podfile` 配置
2. 运行 `pod install`
3. 检查 `Info.plist` 配置

## 获取详细错误信息

### 方法 1: 使用错误边界

应用已包含 `ErrorBoundary` 组件，如果崩溃会显示错误信息。

### 方法 2: 添加全局错误处理

在 `index.js` 中添加:
```javascript
if (__DEV__) {
    const originalError = console.error;
    console.error = (...args) => {
        originalError(...args);
        // 可以在这里发送错误到日志服务
    };
}
```

### 方法 3: 使用 React Native Debugger

1. 安装 React Native Debugger
2. 运行应用
3. 摇动设备，选择 "Debug"
4. 在 Debugger 中查看错误

## 联系支持

如果问题仍然存在，请提供以下信息：

1. 错误日志（完整的 logcat 或 Xcode 日志）
2. 使用的平台（Android/iOS）
3. React Native 版本
4. Node 版本
5. 操作系统版本

