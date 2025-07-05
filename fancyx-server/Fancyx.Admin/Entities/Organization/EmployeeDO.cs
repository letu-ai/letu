using Fancyx.Repository.BaseEntity;
using Fancyx.Core.Interfaces;
using FreeSql.DataAnnotations;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Fancyx.Shared.Enums;

namespace Fancyx.Admin.Entities.Organization
{
    /// <summary>
    /// 员工表
    /// </summary>
    [Table(Name = "org_employee")]
    public class EmployeeDO : FullAuditedEntity, ITenant
    {
        /// <summary>
        /// 工号
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false)]
        public string? Code { get; set; }

        /// <summary>
        /// 姓名
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false)]
        public string? Name { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        [DefaultValue(0)]
        [Column(IsNullable = false)]
        public SexType Sex { get; set; }

        /// <summary>
        /// 手机号码
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(16)]
        [Column(IsNullable = false)]
        public string? Phone { get; set; }

        /// <summary>
        /// 身份证
        /// </summary>
        [StringLength(32)]
        public string? IdNo { get; set; }

        /// <summary>
        /// 身份证正面
        /// </summary>
        [StringLength(512)]
        public string? FrontIdNoUrl { get; set; }

        /// <summary>
        /// 身份证背面
        /// </summary>
        [StringLength(512)]
        public string? BackIdNoUrl { get; set; }

        /// <summary>
        /// 生日
        /// </summary>
        public DateTime? Birthday { get; set; }

        /// <summary>
        /// 现住址
        /// </summary>
        [StringLength(512)]
        public string? Address { get; set; }

        /// <summary>
        /// 邮箱
        /// </summary>
        [StringLength(64)]
        [EmailAddress]
        public string? Email { get; set; }

        /// <summary>
        /// 入职时间
        /// </summary>
        public DateTime InTime { get; set; }

        /// <summary>
        /// 离职时间
        /// </summary>
        public DateTime? OutTime { get; set; }

        /// <summary>
        /// 状态 1正常2离职
        /// </summary>
        public int Status { get; set; }

        /// <summary>
        /// 关联用户ID
        /// </summary>
        public Guid? UserId { get; set; }

        /// <summary>
        /// 部门ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid DeptId { get; set; }

        /// <summary>
        /// 职位ID
        /// </summary>
        [Column(IsNullable = false)]
        public Guid PositionId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }
    }
}