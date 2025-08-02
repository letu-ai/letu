using System.Text;
using Microsoft.IdentityModel.Tokens;

/// <summary>
/// JWT配置选项，用于映射appsettings.json中的JWT配置
/// </summary>
public class JwtOptions {
    /// <summary>
    /// JWT令牌签发配置
    /// </summary>
    public required JwtIssuanceSettings Issuance { get; set; }

    /// <summary>
    /// JWT令牌验证配置
    /// </summary>
    public required JwtValidationSettings Validation { get; set; }
}

/// <summary>
/// JWT令牌签发配置
/// </summary>
public class JwtIssuanceSettings {
    /// <summary>
    /// 签发者（发行方标识符）
    /// </summary>
    public required string Issuer { get; set; }

    /// <summary>
    /// 目标受众（接收方标识符）
    /// </summary>
    public required string Audience { get; set; }

    /// <summary>
    /// 令牌有效期（秒）
    /// </summary>
    public int ExpirySeconds { get; set; }

    /// <summary>
    /// 签名密钥，用于生成签名
    /// </summary>
    public required string SecurityKey { get; set; }
}


/// <summary>
/// JWT令牌验证配置
/// </summary>
public class JwtValidationSettings {
    /// <summary>
    /// 是否验证签发者
    /// </summary>
    public bool ValidateIssuer { get; set; } = true;

    /// <summary>
    /// 合法的签发者，当ValidateIssuer为true时必须提供
    /// </summary>
    public string? ValidIssuer { get; set; }

    /// <summary>
    /// 是否验证接收方
    /// </summary>
    public bool ValidateAudience { get; set; } = true;

    /// <summary>
    /// 合法的接收方，当ValidateAudience为true时必须提供
    /// </summary>
    public string? ValidAudience { get; set; }

    /// <summary>
    /// 是否验证令牌有效期
    /// 默认true
    /// </summary>
    public bool ValidateLifetime { get; set; } = true;

    /// <summary>
    /// 时钟偏差容忍时间（秒），用于处理服务器之间的时间差异
    /// 默认300秒
    /// </summary>
    public int ClockSkewSeconds { get; set; } = 300;

    /// <summary>
    /// 是否要求令牌必须签名
    /// 默认true
    /// </summary>
    public bool RequireSignedTokens { get; set; } = true;

    /// <summary>
    /// 验证签名的密钥
    /// </summary>
    public string? SecurityKey { get; set; }


    /// <summary>
    /// 是否要求通过HTTPS传输令牌
    /// </summary>
    public bool RequireHttps { get; set; } = true;
}


public static class JwtIssuanceSettingsExtensions {
    /// <summary>
    /// 获取签发者的安全密钥
    /// </summary>
    public static SymmetricSecurityKey GetIssuanceSecurityKey(this JwtOptions settings) {
        return GetSecurityKey(settings.Issuance.SecurityKey);
    }

    /// <summary>
    /// 获取验证者的安全密钥，如果验证者没有提供，则使用签发者的安全密钥
    /// </summary>
    public static SymmetricSecurityKey GetValidationSecurityKey(this JwtOptions settings) {
        return GetSecurityKey(settings.Validation.SecurityKey ?? settings.Issuance.SecurityKey);
    }

    private static SymmetricSecurityKey GetSecurityKey(string key) {
        var keyData = Encoding.UTF8.GetBytes(key);
        if (keyData.Length < 256 / 8)
            throw new Exception($"JWT的密钥长度至少32个字母，现在只有{key.Length}个。");
        return new SymmetricSecurityKey(keyData);
    }
}