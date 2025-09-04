using Letu.Core.Applications;
using System.ComponentModel.DataAnnotations;

namespace Letu.Basis.Admin.DataDictionaries.Dtos;

public class ItemListInput : PagedResultRequest
{
    /// <summary>
    /// 搜索名称或者值的关键字
    /// </summary>
    [MaxLength(50)]
    public string? Keywords { get; set; }
}