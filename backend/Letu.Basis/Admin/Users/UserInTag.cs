using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users
{
    /// <summary>
    /// 用户标签关联表
    /// </summary>
    [Table(Name = "sys_user_tag_relation")]
    public class UserInTag : Entity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 用户ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid UserId { get; set; }

        /// <summary>
        /// 标签ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid TagId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}