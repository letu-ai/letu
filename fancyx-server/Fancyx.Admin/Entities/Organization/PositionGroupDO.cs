using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

using Fancyx.Core.Interfaces;
using Fancyx.Repository.BaseEntity;

using FreeSql.DataAnnotations;

namespace Fancyx.Admin.Entities.Organization
{
    /// <summary>
    /// 职位分组
    /// </summary>
    [Table(Name = "org_position_group")]
    public class PositionGroupDO : AuditedEntity, ITenant
    {
        /// <summary>
        /// 分组名
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(64)]
        [Column(IsNullable = false)]
        public string? GroupName { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [StringLength(512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 父ID
        /// </summary>
        public Guid? ParentId { get; set; }

        /// <summary>
        /// 层级父ID
        /// </summary>
        [StringLength(1024)]
        public string? ParentIds { get; set; }

        /// <summary>
        /// 排序值
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public int Sort { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public string? TenantId { get; set; }

        [Navigate(nameof(ParentId))]
        public PositionGroupDO? Parent { get; set; }

        [Navigate(nameof(ParentId))]
        public List<PositionGroupDO>? Children { get; set; }
    }
}