using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.DataDictionary
{
    /// <summary>
    /// 字典数据表
    /// </summary>
    [Table(Name = "sys_dict_data")]
    public class DictionaryItem : AuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 字典值
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(256)]
        [Column(IsNullable = false, StringLength = 256)]
        public required string Value { get; set; }

        /// <summary>
        /// 显示文本
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(128)]
        [Column(IsNullable = false, StringLength = 128)]
        public required string Label { get; set; }

        /// <summary>
        /// 字典类型
        /// </summary>
        [NotNull]
        [Required]
        [StringLength(128)]
        [Column(IsNullable = false, StringLength = 128)]
        public required string DictType { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [StringLength(512)]
        [Column(StringLength = 512)]
        public string? Remark { get; set; }

        /// <summary>
        /// 排序值
        /// </summary>
        [Column(IsNullable = false)]
        public int Sort { get; set; }

        /// <summary>
        /// 是否开启
        /// </summary>
        public bool IsEnabled { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        [Column(IsNullable = true, StringLength = 18)]
        public Guid? TenantId { get; set; }
    }
}