namespace Fancyx.Admin.IService.System.Dtos;

public class TenantResultDto
{
    public Guid Id { get; set; }

    /// <summary>
    /// 租户名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 租户标识
    /// </summary>
    public string? TenantId { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    public string? Remark { get; set; }
}