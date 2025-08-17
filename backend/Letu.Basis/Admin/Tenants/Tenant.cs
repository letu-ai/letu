using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;

namespace Letu.Basis.Admin.Tenants
{
    [Table(Name = "sys_tenant")]
    public class Tenant : AuditedEntity<Guid>
    {
        /// <summary>
        /// 租户名称
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false)]
        public string? Name { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [StringLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 版本ID
        /// </summary>
        public Guid? EditionId { get; set; }

        /// <summary>
        /// 绑定域名
        /// </summary>
        [StringLength(128)]
        public string? BindDomain { get; set; }

        /// <summary>
        /// 失效日期
        /// </summary>
        public DateTime? ExpireDate { get; set; }

        /// <summary>
        /// 联系人姓名
        /// </summary>
        [StringLength(64)]
        public string? ContactName { get; set; }

        /// <summary>
        /// 联系电话
        /// </summary>
        [StringLength(32)]
        public string? ContactPhone { get; set; }

        /// <summary>
        /// 管理员邮箱
        /// </summary>
        [StringLength(128)]
        public string? AdminEmail { get; set; }

        /// <summary>
        /// 网站名称
        /// </summary>
        [StringLength(128)]
        public string? WebsiteName { get; set; }

        /// <summary>
        /// Logo
        /// </summary>
        [StringLength(256)]
        public string? Logo { get; set; }

        /// <summary>
        /// ICP备案号
        /// </summary>
        [StringLength(64)]
        public string? IcpNumber { get; set; }

        /// <summary>
        /// 有效状态
        /// </summary>
        public bool IsActive { get; set; } = true;
    }
}