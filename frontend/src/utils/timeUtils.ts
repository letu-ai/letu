import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';
import 'dayjs/locale/zh-cn';

// 配置dayjs
dayjs.extend(relativeTime);
dayjs.locale('zh-cn');

/**
 * 格式化时间为人性化显示
 * @param time 时间字符串
 * @returns 人性化时间显示（如：5分钟前）
 */
export function formatTimeFromNow(time: string | undefined): string {
  if (!time) return '';
  return dayjs(time).fromNow();
}

/**
 * 格式化时间为标准格式
 * @param time 时间字符串
 * @param format 格式化模板，默认为 'YYYY-MM-DD HH:mm:ss'
 * @returns 格式化后的时间字符串
 */
export function formatTime(time: string | undefined, format = 'YYYY-MM-DD HH:mm:ss'): string {
  if (!time) return '';
  return dayjs(time).format(format);
}