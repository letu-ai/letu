namespace Letu.Logging.BusinessLogs;

public interface IBusinessLogScope
{
    void AddVariable(string name, object value);
    IDictionary<string, object>? GetVariables();
}


public static class BusinessLogScopeExtensions
{
    /// <summary>
    /// 添加业务实体ID，这个ID会写入到业务日志表的BizNo字段，以后可以通过这个ID查询一个实体的所有操作记录。
    /// </summary>
    /// <param name="scope">业务日志作用域</param>
    /// <param name="entityId">业务实体ID</param>
    public static void AddEntityId(this IBusinessLogScope scope, Guid entityId)
    {
        scope.AddVariable("EntityId", entityId.ToString());
    }

    /// <summary>
    /// 添加业务实体ID，这个ID会写入到业务日志表的BizNo字段，以后可以通过这个ID查询一个实体的所有操作记录。
    /// </summary>
    /// <param name="scope">业务日志作用域</param>
    /// <param name="entityId">业务实体ID</param>
    public static void AddEntityId(this IBusinessLogScope scope, string entityId)
    {
        scope.AddVariable("EntityId", entityId);
    }
}