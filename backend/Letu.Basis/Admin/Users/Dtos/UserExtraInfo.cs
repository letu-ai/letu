using Letu.Basis.Admin.UserTags.Dtos;

namespace Letu.Basis.Admin.Users.Dtos;

/// <summary>
/// 用户机构、部门、职位信息等扩展信息。
/// </summary>
public class UserExtraInfo
{
    /// <summary>
    /// 机构ID
    /// </summary>
    public Guid? OrganizationUnitId { get; set; }

    /// <summary>
    /// 机构名称
    /// </summary>
    public string? OrganizationUnitName { get; set; }

    /// <summary>
    /// 部门ID
    /// </summary>
    public Guid? DepartmentId { get; set; }

    /// <summary>
    /// 部门名称
    /// </summary>
    public string? DepartmentName { get; set; }

    /// <summary>
    /// 职位ID
    /// </summary>
    public Guid? PositionId { get; set; }

    /// <summary>
    /// 职位名称
    /// </summary>
    public string? PositionName { get; set; }

    /// <summary>
    /// 用户标签
    /// </summary>
    public List<UserTagInfo>? Tags { get; set; }
}