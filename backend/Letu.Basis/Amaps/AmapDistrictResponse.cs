namespace Letu.Basis.Amaps;

/// <summary>
/// 行政区域响应
/// </summary>
public class AmapDistrictResponse
{
    /// <summary>
    /// 返回状态："0"表示失败；"1"表示成功
    /// </summary>
    public string Status { get; set; } = string.Empty;

    /// <summary>
    /// 返回结果状态信息
    /// </summary>
    public string Info { get; set; } = string.Empty;

    /// <summary>
    /// 返回状态说明，10000代表正确
    /// </summary>
    public string InfoCode { get; set; } = string.Empty;

    /// <summary>
    /// 行政区域列表
    /// </summary>
    public AmapDistrict[]? Districts { get; set; }
}
