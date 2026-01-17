using Letu.Basis.Admin.UserDevices;
using Letu.Basis.Admin.UserDevices.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize]
[ApiController]
[Route("api/admin/user-devices")]
public class UserDeviceController : ControllerBase
{
    private readonly IUserDeviceAppService userDeviceAppService;

    public UserDeviceController(IUserDeviceAppService userDeviceAppService)
    {
        this.userDeviceAppService = userDeviceAppService;
    }

    /// <summary>
    /// 获取用户设备列表
    /// </summary>
    /// <param name="input">查询条件</param>
    [HttpGet]
    [Authorize(BasisPermissions.UserDevice.Default)]
    public async Task<PagedResult<UserDeviceListOutput>> GetUserDeviceListAsync([FromQuery] UserDeviceListInput input)
    {
        return await userDeviceAppService.GetUserDeviceListAsync(input);
    }
}
