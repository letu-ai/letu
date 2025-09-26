using System.Text.Json.Serialization.Metadata;
using Volo.Abp.Security.Encryption;

namespace Letu.Core.Security.Serialization;

/// <summary>
/// 为标记 <see cref="EncryptedStringAttribute"/> 特性的属性提供加密序列化处理
/// </summary>
public class EncryptedPropertyModifier
{
    private readonly IStringEncryptionService encryptionService;

    public EncryptedPropertyModifier(IStringEncryptionService encryptionService)
    {
        this.encryptionService = encryptionService;
    }

    public void ModifyTypeInfo(JsonTypeInfo typeInfo)
    {
        // 实现修饰器逻辑
        foreach (var property in typeInfo.Properties)
        {
            if (ShouldEncrypt(property))
            {
                // 保存原始的 Get 和 Set 方法
                var originalGet = property.Get;
                var originalSet = property.Set;

                // 重写 Get 方法：在序列化时（获取属性值时）加密
                property.Get = (obj) =>
                {
                    var originalValue = originalGet?.Invoke(obj) as string;
                    if (string.IsNullOrEmpty(originalValue))
                    {
                        return originalValue;
                    }
                    return encryptionService.Encrypt(originalValue);
                };

                // 重写 Set 方法：在反序列化时（设置属性值时）解密
                property.Set = (obj, value) =>
                {
                    if (value == null)
                    {
                        originalSet?.Invoke(obj, value);
                    }
                    else
                    {
                        var decryptedValue = encryptionService.Decrypt(value as string);
                        originalSet?.Invoke(obj, decryptedValue);
                    }
                };
            }
        }
    }

    private static bool ShouldEncrypt(JsonPropertyInfo property)
    {
        // 检查是否标记了加密特性
        if (property.PropertyType == typeof(string) &&
           property.AttributeProvider?.IsDefined(typeof(EncryptedStringAttribute), inherit: true) == true)
        {
            return true;
        }

        return false;
    }
}
