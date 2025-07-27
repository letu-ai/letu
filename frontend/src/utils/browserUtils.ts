import FingerprintJS from '@fingerprintjs/fingerprintjs';

const BrowserUtils = {
  /**
   * 获取浏览器指纹
   */
  async getBrowserCode(): Promise<string> {
    try {
      // 初始化指纹库
      const fp = await FingerprintJS.load();

      // 获取指纹结果
      const result = await fp.get();

      // 返回指纹ID（哈希值）
      return result.visitorId;
    } catch (error) {
      console.error('Failed to get browser fingerprint:', error);
      return 'error';
    }
  },
};

export default BrowserUtils;
