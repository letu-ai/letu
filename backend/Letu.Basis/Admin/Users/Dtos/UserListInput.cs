using Letu.Core.Applications;

namespace Letu.Basis.Admin.Users.Dtos;

public class UserListInput : PagedResultRequest
{
    public string? Keyword { get; set; }

    /// <summary>
    /// 组织单元ID（包含子孙机构）
    /// </summary>
    public Guid? OrganizationUnitId { get; set; }

    /// <summary>
    /// 标签ID列表（OR筛选）
    /// </summary>
    public List<Guid>? TagIds { get; set; }
}