using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.OrganizationUnits.Dtos;

public class OrganizationUnitListOutput
{
    public Guid Id { get; set; }

    /// <summary>
    /// 组织机构名称（同级唯一，忽略大小写）
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 排序
    /// </summary>
    public int Sort { get; set; }

    /// <summary>
    /// 上级ID
    /// </summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// 分类（用于机构种类）
    /// </summary>
    public string Category { get; set; } = string.Empty;

    /// <summary>
    /// 类型（值来自字典项的 Value）
    /// </summary>
    public string? Type { get; set; }

    /// <summary>
    /// 所属行政区域（关联 Region.Code）
    /// </summary>
    public string? RegionCode { get; set; }

    /// <summary>
    /// 行政区域街道名称
    /// </summary>
    public string? StreetName { get; set; }

    /// <summary>
    /// 地址
    /// </summary>
    public string? Address { get; set; }

    /// <summary>
    /// 联系人
    /// </summary>
    public string? ContactPerson { get; set; }

    /// <summary>
    /// 联系电话
    /// </summary>
    public string? ContactPhone { get; set; }

    /// <summary>
    /// 经度
    /// </summary>
    public decimal? Longitude { get; set; }

    /// <summary>
    /// 纬度
    /// </summary>
    public decimal? Latitude { get; set; }
}
