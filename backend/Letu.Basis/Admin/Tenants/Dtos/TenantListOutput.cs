namespace Letu.Basis.Admin.Tenants.Dtos;

public class TenantListOutput
{
    public Guid Id { get; set; }

    /// <summary>
    /// 租户名称
    /// </summary>
    public string? Name { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    public string? Remark { get; set; }
    
    /// <summary>
    /// 版本ID
    /// </summary>
    public Guid? EditionId { get; set; }

    /// <summary>
    /// 版本名称
    /// </summary>
    public string? EditionName { get; set; }
    
    /// <summary>
    /// 绑定域名
    /// </summary>
    public string? BindDomain { get; set; }
    
    /// <summary>
    /// 失效日期
    /// </summary>
    public DateTime? ExpireDate { get; set; }
    
    /// <summary>
    /// 联系人姓名
    /// </summary>
    public string? ContactName { get; set; }
    
    /// <summary>
    /// 联系电话
    /// </summary>
    public string? ContactPhone { get; set; }
    
    /// <summary>
    /// 管理员邮箱
    /// </summary>
    public string? AdminEmail { get; set; }
    
    /// <summary>
    /// 网站名称
    /// </summary>
    public string? WebsiteName { get; set; }
    
    /// <summary>
    /// Logo
    /// </summary>
    public string? Logo { get; set; }
    
    /// <summary>
    /// ICP备案号
    /// </summary>
    public string? IcpNumber { get; set; }
    
    /// <summary>
    /// 有效状态
    /// </summary>
    public bool IsActive { get; set; }
}