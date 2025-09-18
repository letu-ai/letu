namespace Letu.Basis.Amaps;

public class AmapPoiResponse
{
    /// <summary>
    /// 0表示失败；1表示成功
    /// </summary>
    public required string Status { get; set; }

    /// <summary>
    /// 当 status 为 0 时，info 会返回具体错误原因，否则返回“OK”。
    /// </summary>
    public required string Info { get; set; }

    /// <summary>
    /// 返回状态说明，10000代表正确
    /// </summary>
    public required string InfoCode { get; set; }

    /// <summary>
    /// 返回结果的个数
    /// </summary>
    public int Count { get; set; }

    /// <summary>
    /// POI 列表
    /// </summary>
    public AmapPoi[]? Pois { get; set; }
}
