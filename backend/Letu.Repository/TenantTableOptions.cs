using System.Reflection;

namespace Letu.Repository;

/// <summary>
/// 租户表配置选项
/// </summary>
public class TenantTableOptions
{
    /// <summary>
    /// 存储各模块注册的程序集
    /// </summary>
    public List<Assembly> EntityAssemblies { get; } = new();
    
    /// <summary>
    /// 添加程序集
    /// </summary>
    /// <param name="assembly">程序集</param>
    /// <returns>返回当前实例，支持链式调用</returns>
    public TenantTableOptions AddAssembly(Assembly assembly)
    {
        if (assembly != null && !EntityAssemblies.Contains(assembly))
        {
            EntityAssemblies.Add(assembly);
        }
        return this;
    }
}

