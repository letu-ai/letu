using Letu.Core.Applications;
using Letu.Basis.Identity;

namespace Letu.Basis.Admin.UserDevices.Dtos;

/// <summary>
/// 用户设备列表查询输入
/// </summary>
public class UserDeviceListInput : PagedResultRequest
{
    /// <summary>
    /// 用户ID(可选,用于查询特定用户的设备)
    /// </summary>
    public Guid? UserId { get; set; }

    /// <summary>
    /// 用户名(模糊搜索)
    /// </summary>
    public string? UserName { get; set; }

    /// <summary>
    /// 客户端类型筛选
    /// </summary>
    public ClientType? ClientType { get; set; }

    /// <summary>
    /// 应用包名筛选
    /// </summary>
    public string? PackageName { get; set; }
}
