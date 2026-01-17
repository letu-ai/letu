namespace Letu.MobilePush;

/// <summary>
/// 移动推送服务接口
/// </summary>
public interface IMobilePushService
{
    /// <summary>
    /// 向指定设备推送消息
    /// </summary>
    /// <param name="packageName">应用包名(用于选择具体的App配置)</param>
    /// <param name="deviceIds">设备ID列表</param>
    /// <param name="title">消息标题</param>
    /// <param name="body">消息内容</param>
    /// <returns>推送结果</returns>
    Task<PushResult> PushToDeviceAsync(
        PushType pushType,
        string packageName,
        List<string> deviceIds,
        string title,
        string body);

    /// <summary>
    /// 向指定账号推送消息
    /// </summary>
    /// <param name="packageName">应用包名</param>
    /// <param name="accounts">账号列表</param>
    /// <param name="title">消息标题</param>
    /// <param name="body">消息内容</param>
    /// <returns>推送结果</returns>
    Task<PushResult> PushToAccountAsync(
        PushType pushType,
        string packageName,
        List<string> accounts,
        string title,
        string body);
}
