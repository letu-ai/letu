namespace Letu.Basis.Notifications;

/// <summary>
/// 目标平台（位标志枚举）
/// </summary>
[Flags]
public enum TargetPlatform
{
    /// <summary>
    /// 无
    /// </summary>
    None = 0,

    /// <summary>
    /// Web端（SSE推送）
    /// </summary>
    Web = 1,

    /// <summary>
    /// Android
    /// </summary>
    Android = 2,

    /// <summary>
    /// iOS
    /// </summary>
    iOS = 4,

    /// <summary>
    /// 鸿蒙
    /// </summary>
    HarmonyOS = 8,

    /// <summary>
    /// 所有移动端
    /// </summary>
    Mobile = Android | iOS | HarmonyOS,

    /// <summary>
    /// 全部平台
    /// </summary>
    All = Web | Mobile
}
