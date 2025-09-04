namespace Letu.Basis.Amaps;

/// <summary>
/// 地理编码响应
/// </summary>
public class AmapGeoCodeResponse
{
    /// <summary>
    /// 0表示失败；1表示成功
    /// </summary>
    public int Status { get; set; }

    /// <summary>
    /// 返回结果的个数
    /// </summary>
    public int Count { get; set; }

    /// <summary>
    /// 当 status 为 0 时，info 会返回具体错误原因，否则返回“OK”。
    /// </summary>
    public required string Info { get; set; }

    /// <summary>
    /// 地理编码列表
    /// </summary>
    public required AmapGeoCode[] GeoCodes { get; set; }
}
