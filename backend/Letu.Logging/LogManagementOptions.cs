namespace Letu.Logging;

public class LogManagementOptions
{
    public string CleanupScheduleCron { get; set; } = "0 0 2 * * ?"; // 每天凌晨2点执行

    public SystemLogOptions SystemLog { get; set; } = new();

    public AuditLogOptions AuditLog { get; set; } = new();

    public BusinessLogOptions BusinessLog { get; set; } = new();
}

public class SystemLogOptions
{
    public string LogDirectory { get; set; } = "logs";
    public int RetentionDays { get; set; } = 31;
    public int CompressAfterDays { get; set; } = 7;
}

public class AuditLogOptions
{
    /// <summary>
    /// 审计日志保留天数
    /// </summary>
    public int RetentionDays { get; set; } = 90;
}

public class BusinessLogOptions
{
    /// <summary>
    /// 业务日志保留天数
    /// </summary>
    public int RetentionDays { get; set; } = 90;
}