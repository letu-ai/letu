using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.UserTags
{
    /// <summary>
    /// 用户标签表
    /// </summary>
    [Table(Name = "sys_user_tag")]
    public class UserTag : FullAuditedEntity<Guid>, IMultiTenant
    {
        protected UserTag()
        {
        }

        public UserTag(Guid id, string name) : base(id)
        {
            Name = name;
        }

        /// <summary>
        /// 标签名称
        /// </summary>
        [Required]
        [StringLength(32)]
        [Column(IsNullable = false, StringLength = 32)]
        public required string Name { get; set; }

        /// <summary>
        /// 标签颜色（Hex格式，如 #1890ff）
        /// </summary>
        [StringLength(16)]
        [Column(IsNullable = true, StringLength = 16)]
        public string? Color { get; set; }

        /// <summary>
        /// 排序号
        /// </summary>
        [Column(IsNullable = false)]
        public int Sort { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}