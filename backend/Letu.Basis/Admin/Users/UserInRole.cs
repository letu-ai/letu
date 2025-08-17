using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users
{
    /// <summary>
    /// 用户角色关联表
    /// </summary>
    [Table(Name = "sys_user_role")]
    public class UserInRole : Entity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid UserId { get; set; }

        /// <summary>
        /// 角色ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid RoleId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}