using FreeSql.DataAnnotations;
using Letu.Basis.Admin.UserTags;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users;

/// <summary>
/// 用户标签关联表
/// </summary>
[Table(Name = "sys_user_tag_relation")]
[Index("uk_user_in_tag", "UserId,TagId", true)]
public class UserInTag : Entity, IMultiTenant
{
    /// <summary>
    /// 租户ID
    /// </summary>
    [Column(IsNullable = true, StringLength = 18)]
    public Guid? TenantId { get; set; }
    
    /// <summary>
    /// 用户ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    [Navigate(nameof(UserId))]
    public User? User { get; set; }

    /// <summary>
    /// 标签ID
    /// </summary>
    [Column(IsNullable = false)]
    public Guid TagId { get; set; }


    [Navigate(nameof(TagId))]
    public UserTag? Role { get; set; }

    public override object?[] GetKeys()
    {
        return [UserId, TagId];
    }
}