namespace Letu.Basis.Admin.Regions.Dtos;

/// <summary>
/// 行政区域导入进度
/// </summary>
public class RegionImportProgressDto
{
    /// <summary>
    /// 进度百分比（0-100）
    /// </summary>
    public int Percentage { get; set; }

    /// <summary>
    /// 当前正在处理的省份名称
    /// </summary>
    public string CurrentProvince { get; set; } = string.Empty;

    /// <summary>
    /// 已完成的省份数
    /// </summary>
    public int Current { get; set; }

    /// <summary>
    /// 总省份数
    /// </summary>
    public int Total { get; set; }

    /// <summary>
    /// 是否正在导入
    /// </summary>
    public bool IsImporting { get; set; }
}