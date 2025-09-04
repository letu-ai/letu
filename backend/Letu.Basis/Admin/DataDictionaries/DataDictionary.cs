using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.DataDictionaries
{
    /// <summary>
    /// 字典类型表
    /// </summary>
    [Table(Name = "sys_data_dictionary")]
    public class DataDictionary : AuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 字典名称
        /// </summary>
        [Column(IsNullable = false, StringLength = 128)]
        public required string Name { get; set; }
        
        /// <summary>
        /// 字典名称
        /// </summary>
        [Column(IsNullable = false, StringLength = 128)]
        public required string DisplayName { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        [Column(StringLength = 512)]
        public string? Remark { get; set; }

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