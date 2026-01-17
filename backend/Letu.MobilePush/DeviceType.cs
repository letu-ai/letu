namespace Letu.MobilePush;

/// <summary>
/// 设备类型
/// </summary>
public enum DeviceType
{
    /// <summary>
    /// Android设备
    /// </summary>
    ANDROID = 0,

    /// <summary>
    /// iOS设备
    /// </summary>
    IOS = 1,

    /// <summary>
    /// 鸿蒙设备
    /// </summary>
    HARMONY = 3,

    /// <summary>
    /// 全部设备(仅当AppKey支持多端时有效)
    /// </summary>
    ALL = 99
}
