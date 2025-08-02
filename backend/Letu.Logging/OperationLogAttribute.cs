namespace Letu.Logging;

/// <summary>
/// 操作日志记录，加在需要记录业务日志的AppService方法上
/// </summary>
[AttributeUsage(AttributeTargets.Method, Inherited = true, AllowMultiple = false)]
public class OperationLogAttribute : Attribute
{
    public string Type { get; init; }
    public string SubType { get; init; }
    public string BizNo { get; init; }
    public string Content { get; init; }

    public OperationLogAttribute(string type, string subType, string bizNo, string content)
    {
        Type = type;
        SubType = subType;
        BizNo = bizNo;
        Content = content;
    }
}