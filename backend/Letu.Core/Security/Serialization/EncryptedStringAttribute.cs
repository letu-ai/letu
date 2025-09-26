namespace Letu.Core.Security.Serialization;

/// <summary>
/// Json序列化时对属性值加密。
/// 注意：
/// 1. 该特性只能应用于string类型的属性；
/// 2. 需要在JsonSerializerOptions中注册EncryptedPropertyModifier。
/// </summary>
[AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
public class EncryptedStringAttribute : Attribute
{
    public EncryptedStringAttribute()
    {
    }
}