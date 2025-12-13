using FreeSql.DataAnnotations;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Employees
{
    /// <summary>
    /// 员工表
    /// </summary>
    [Table(Name = "org_employee")]
    public class Employee : FullAuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 工号
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false, StringLength = 64)]
        public string? Code { get; set; }

        /// <summary>
        /// 姓名
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false, StringLength = 64)]
        public string? Name { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        [DefaultValue(0)]
        [Column(IsNullable = false)]
        public SexType Sex { get; set; }

        /// <summary>
        /// 身份证
        /// </summary>
        [StringLength(32)]
        [Column(StringLength = 32)]
        public string? IdNo { get; set; }

        /// <summary>
        /// 身份证正面
        /// </summary>
        [StringLength(512)]
        [Column(StringLength = 512)]
        public string? FrontIdNoUrl { get; set; }

        /// <summary>
        /// 身份证背面
        /// </summary>
        [StringLength(512)]
        [Column(StringLength = 512)]
        public string? BackIdNoUrl { get; set; }

        /// <summary>
        /// 生日
        /// </summary>
        public DateTime? Birthday { get; set; }

        /// <summary>
        /// 现住址
        /// </summary>
        [StringLength(512)]
        [Column(StringLength = 512)]
        public string? Address { get; set; }

        /// <summary>
        /// 入职时间
        /// </summary>
        public DateOnly? InTime { get; set; }

        /// <summary>
        /// 离职时间
        /// </summary>
        public DateOnly? OutTime { get; set; }

        /// <summary>
        /// 状态 1正常2离职
        /// </summary>
        public int Status { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}