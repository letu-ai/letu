using Letu.Basis.Admin.UserDevices;
using Letu.Basis.Admin.UserDevices.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Account;

[Authorize]
[ApiController]
[Route("api/account/user-devices")]
public class UserDeviceController : ControllerBase
{
    private readonly IUserDeviceAppService userDeviceAppService;

    public UserDeviceController(IUserDeviceAppService userDeviceAppService)
    {
        this.userDeviceAppService = userDeviceAppService;
    }

    /// <summary>
    /// 保存或更新当前用户的设备信息
    /// </summary>
    /// <param name="input">设备信息</param>
    [HttpPost]
    public async Task SaveUserDeviceAsync([FromBody] SaveUserDeviceInput input)
    {
        await userDeviceAppService.SaveUserDeviceAsync(input);
    }

    /// <summary>
    /// 删除当前用户的设备信息
    /// </summary>
    /// <param name="deviceId">设备ID</param>
    /// <param name="packageName">应用包名</param>
    [HttpDelete]
    public async Task DeleteUserDeviceAsync([FromQuery] string deviceId, [FromQuery] string packageName)
    {
        await userDeviceAppService.DeleteUserDeviceAsync(deviceId, packageName);
    }
}
