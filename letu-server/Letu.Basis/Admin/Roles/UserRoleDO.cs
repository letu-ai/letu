using Letu.Repository.BaseEntity;
using Letu.Core.Interfaces;
using FreeSql.DataAnnotations;

namespace Letu.Basis.Entities.System
{
    /// <summary>
    /// 用户角色关联表
    /// </summary>
    [Table(Name = "sys_user_role")]
    public class UserRoleDO : Entity, ITenant
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
        public string? TenantId { get; set; }
    }
}