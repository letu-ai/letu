namespace Letu.Logging.BusinessLogs;

/// <summary>
/// 操作日志记录，加在需要记录业务日志的AppService方法上
/// </summary>
[AttributeUsage(AttributeTargets.Method, Inherited = true, AllowMultiple = false)]
public class BusinessLogAttribute : Attribute
{
    public BusinessLogAttribute(string type, string subType, string content, string? bizNo = null)
    {
        Type = type;
        SubType = subType;
        Content = content;
        EntityId = bizNo;
    }

    public string Type { get; init; }
    public string SubType { get; init; }

    /// <summary>
    /// 记录操作实体ID，比如订单ID、用户ID等
    /// </summary>
    public string? EntityId { get; init; }
    public string Content { get; init; }
}