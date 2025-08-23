using Letu.Core.Applications;

namespace Letu.Basis.Admin.Tenants.Dtos;

public class TenantListInput : PagedResultRequest
{
    /// <summary>
    /// 租户名称/标识
    /// </summary>
    public string? Keyword { get; set; }
}