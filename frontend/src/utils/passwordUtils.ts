/**
 * 密码验证相关工具函数
 */

/**
 * 密码配置接口
 */
export interface PasswordConfig {
  requiredLength: number;
  requiredUniqueChars: number;
  requireNonAlphanumeric: boolean;
  requireLowercase: boolean;
  requireUppercase: boolean;
  requireDigit: boolean;
}

/**
 * 密码强度结果
 */
export interface PasswordStrengthResult {
  score: number;
  strength: 'weak' | 'fair' | 'good' | 'strong';
  color: string;
  text: string;
  violations: string[];
}

/**
 * 密码验证结果
 */
export interface PasswordValidationResult {
  isValid: boolean;
  errors: string[];
}

/**
 * 获取密码中唯一字符的数量
 */
function getUniqueCharCount(password: string): number {
  return new Set(password).size;
}

/**
 * 检查密码是否包含特殊字符
 */
function hasNonAlphanumeric(password: string): boolean {
  return /[^A-Za-z0-9]/.test(password);
}

/**
 * 检查密码是否包含小写字母
 */
function hasLowercase(password: string): boolean {
  return /[a-z]/.test(password);
}

/**
 * 检查密码是否包含大写字母
 */
function hasUppercase(password: string): boolean {
  return /[A-Z]/.test(password);
}

/**
 * 检查密码是否包含数字
 */
function hasDigit(password: string): boolean {
  return /[0-9]/.test(password);
}

/**
 * 验证密码是否符合配置要求
 */
export function validatePassword(password: string, config: PasswordConfig): PasswordValidationResult {
  const errors: string[] = [];

  // 检查长度
  if (password.length < config.requiredLength) {
    errors.push(`密码长度至少需要${config.requiredLength}位字符`);
  }

  // 检查唯一字符数量
  if (getUniqueCharCount(password) < config.requiredUniqueChars) {
    errors.push(`密码需要至少包含${config.requiredUniqueChars}个不同的字符`);
  }

  // 检查特殊字符
  if (config.requireNonAlphanumeric && !hasNonAlphanumeric(password)) {
    errors.push('密码必须包含特殊字符');
  }

  // 检查小写字母
  if (config.requireLowercase && !hasLowercase(password)) {
    errors.push('密码必须包含小写字母');
  }

  // 检查大写字母
  if (config.requireUppercase && !hasUppercase(password)) {
    errors.push('密码必须包含大写字母');
  }

  // 检查数字
  if (config.requireDigit && !hasDigit(password)) {
    errors.push('密码必须包含数字');
  }

  return {
    isValid: errors.length === 0,
    errors
  };
}

/**
 * 计算密码强度
 */
export function calculatePasswordStrength(password: string, config: PasswordConfig): PasswordStrengthResult {
  if (!password) {
    return {
      score: 0,
      strength: 'weak',
      color: '#f5222d',
      text: '弱',
      violations: []
    };
  }

  let score = 0;
  const violations: string[] = [];
  const maxScore = 100;

  // 基础分数权重配置
  const weights = {
    length: 30,           // 长度权重
    uniqueChars: 20,      // 唯一字符权重
    lowercase: 12.5,      // 小写字母权重
    uppercase: 12.5,      // 大写字母权重
    digit: 12.5,          // 数字权重
    nonAlphanumeric: 12.5 // 特殊字符权重
  };

  // 1. 长度评分
  if (password.length >= config.requiredLength) {
    // 基础长度满足，给予基础分数
    let lengthScore = weights.length;
    
    // 额外长度奖励（每超过要求长度1位，额外加分）
    const extraLength = password.length - config.requiredLength;
    lengthScore += Math.min(extraLength * 2, 20); // 最多额外20分
    
    score += Math.min(lengthScore, weights.length + 20);
  } else {
    violations.push(`长度不足（至少${config.requiredLength}位）`);
    // 部分分数：按比例给分
    score += (password.length / config.requiredLength) * weights.length;
  }

  // 2. 唯一字符评分
  const uniqueCount = getUniqueCharCount(password);
  if (uniqueCount >= config.requiredUniqueChars) {
    score += weights.uniqueChars;
  } else {
    violations.push(`唯一字符不足（至少${config.requiredUniqueChars}个）`);
    // 部分分数
    score += (uniqueCount / config.requiredUniqueChars) * weights.uniqueChars;
  }

  // 3. 小写字母评分
  if (config.requireLowercase) {
    if (hasLowercase(password)) {
      score += weights.lowercase;
    } else {
      violations.push('缺少小写字母');
    }
  } else {
    // 如果不要求但有，也给分
    if (hasLowercase(password)) {
      score += weights.lowercase;
    }
  }

  // 4. 大写字母评分
  if (config.requireUppercase) {
    if (hasUppercase(password)) {
      score += weights.uppercase;
    } else {
      violations.push('缺少大写字母');
    }
  } else {
    // 如果不要求但有，也给分
    if (hasUppercase(password)) {
      score += weights.uppercase;
    }
  }

  // 5. 数字评分
  if (config.requireDigit) {
    if (hasDigit(password)) {
      score += weights.digit;
    } else {
      violations.push('缺少数字');
    }
  } else {
    // 如果不要求但有，也给分
    if (hasDigit(password)) {
      score += weights.digit;
    }
  }

  // 6. 特殊字符评分
  if (config.requireNonAlphanumeric) {
    if (hasNonAlphanumeric(password)) {
      score += weights.nonAlphanumeric;
    } else {
      violations.push('缺少特殊字符');
    }
  } else {
    // 如果不要求但有，也给分
    if (hasNonAlphanumeric(password)) {
      score += weights.nonAlphanumeric;
    }
  }

  // 限制分数范围
  score = Math.max(0, Math.min(score, maxScore));

  // 确定强度等级和颜色
  let strength: 'weak' | 'fair' | 'good' | 'strong';
  let color: string;
  let text: string;

  if (score < 30) {
    strength = 'weak';
    color = '#f5222d';
    text = '弱';
  } else if (score < 60) {
    strength = 'fair';
    color = '#fa8c16';
    text = '一般';
  } else if (score < 85) {
    strength = 'good';
    color = '#fadb14';
    text = '良好';
  } else {
    strength = 'strong';
    color = '#52c41a';
    text = '强';
  }

  return {
    score: Math.round(score),
    strength,
    color,
    text,
    violations
  };
}

/**
 * 生成密码验证规则（用于Ant Design Form）
 */
export function generatePasswordRules(config: PasswordConfig) {
  const rules = [
    {
      required: true,
      message: '请输入密码',
    }
  ];

  // 自定义验证器
  rules.push({
    validator: (_: any, value: string) => {
      if (!value) {
        return Promise.resolve();
      }

      const validation = validatePassword(value, config);
      if (validation.isValid) {
        return Promise.resolve();
      }

      return Promise.reject(new Error(validation.errors[0]));
    }
  });

  return rules;
}

/**
 * 获取密码要求描述列表
 */
export function getPasswordRequirements(config: PasswordConfig): string[] {
  const requirements: string[] = [];

  requirements.push(`长度至少${config.requiredLength}位字符`);
  
  if (config.requiredUniqueChars > 1) {
    requirements.push(`至少包含${config.requiredUniqueChars}个不同的字符`);
  }

  if (config.requireLowercase) {
    requirements.push('至少包含一个小写字母');
  }

  if (config.requireUppercase) {
    requirements.push('至少包含一个大写字母');
  }

  if (config.requireDigit) {
    requirements.push('至少包含一个数字');
  }

  if (config.requireNonAlphanumeric) {
    requirements.push('至少包含一个特殊字符(!@#$%^&*等)');
  }

  return requirements;
}
