using Letu.Basis.Admin.UserDevices.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.UserDevices;

public interface IUserDeviceAppService
{
    /// <summary>
    /// 保存或更新用户设备信息
    /// </summary>
    Task SaveUserDeviceAsync(SaveUserDeviceInput input);

    /// <summary>
    /// 获取用户设备列表
    /// </summary>
    Task<PagedResult<UserDeviceListOutput>> GetUserDeviceListAsync(UserDeviceListInput input);

    /// <summary>
    /// 删除当前用户的设备信息
    /// </summary>
    Task DeleteUserDeviceAsync(string deviceId, string packageName);
}
