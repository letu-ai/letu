using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Roles;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users
{
    /// <summary>
    /// 用户角色关联表
    /// </summary>
    [Table(Name = "sys_user_role")]
    [Index("uk_user_in_role", "UserId,RoleId", true)]
    public class UserInRole : Entity, IMultiTenant
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
        /// 角色ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid RoleId { get; set; }

        [Navigate(nameof(RoleId))]
        public Role? Role { get; set; }

        public override object?[] GetKeys()
        {
            return [UserId, RoleId];
        }
    }
}