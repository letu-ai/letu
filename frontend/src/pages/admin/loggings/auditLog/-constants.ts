/**
 * 审计日志类型
 */
export const AuditLogType = {
  /** 请求审计日志 */
  Request: 'request',
  /** 实体变更审计日志 */
  Entity: 'entity',
} as const;

/**
 * 实体变更类型
 */
export const EntityChangeType = {
  /** 创建 */
  Created: 0,
  /** 更新 */
  Updated: 1,
  /** 删除 */
  Deleted: 2,
} as const; 