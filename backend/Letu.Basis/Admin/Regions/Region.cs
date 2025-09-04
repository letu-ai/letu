using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Regions
{
    /// <summary>
    /// 行政区域表
    /// </summary>
    [Table(Name = "sys_region")]
    public class Region : FullAuditedEntity<int>, IMultiTenant
    {
        [Column(IsPrimary = true, IsIdentity = true)]
        public override int Id { get;protected set; }

        /// <summary>
        /// 父级ID
        /// </summary>
        public int? ParentId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true)]
        public Guid? TenantId { get; set; }

        /// <summary>
        /// 行政区域代码（如：110000北京市、110101东城区）
        /// </summary>
        [Column(IsNullable = false, StringLength = 12)]
        public required string Code { get; set; }

        /// <summary>
        /// 区域名称
        /// </summary>
        [Column(IsNullable = false, StringLength = 64)]
        public required string Name { get; set; }

        /// <summary>
        /// 中心点坐标
        /// </summary>
        [Column(StringLength = 32)]
        public string? Center { get; set; }

        /// <summary>
        /// 级别：1省/直辖市，2市/州，3县/区，4街道/乡镇
        /// </summary>
        [Column(IsNullable = false)]
        public int Level { get; set; }


        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [Column(IsNullable = false)]
        public bool IsEnabled { get; set; } = true;

    }
}