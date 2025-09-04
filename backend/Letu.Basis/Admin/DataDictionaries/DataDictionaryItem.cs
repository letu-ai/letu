using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.DataDictionaries;

/// <summary>
/// 字典数据表
/// </summary>
[Table(Name = "sys_data_dictionary_item")]
public class DataDictionaryItem : AuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 所属字典名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 128)]
    public required string DictionaryName { get; set; }

    /// <summary>
    /// 字典值
    /// </summary>
    [Column(IsNullable = false, StringLength = 256)]
    public required string Value { get; set; }

    /// <summary>
    /// 显示文本
    /// </summary>
    [Column(IsNullable = true, StringLength = 32)]
    public string? Label { get; set; }

    /// <summary>
    /// 备注
    /// </summary>
    [Column(StringLength = 512)]
    public string? Remark { get; set; }

    /// <summary>
    /// 排序值
    /// </summary>
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