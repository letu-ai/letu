using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Logging.BusinessLog)]
[ApiController]
[Route("api/admin/logs/business")]
public class BusinessLogController : ControllerBase
{
    private readonly IBusinessLogAppService businessLogService;

    public BusinessLogController(IBusinessLogAppService businessLogService)
    {
        this.businessLogService = businessLogService;
    }

    /// <summary>
    /// 业务日志分页列表
    /// </summary>
    /// <param name="dto"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<PagedResult<BusinessLogListOutput>> GetBusinessLogListAsync([FromQuery] BusinessLogListInput dto)
    {
        return await businessLogService.GetBusinessLogListAsync(dto);
    }

    /// <summary>
    /// 获取所有业务类型选项
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    [HttpGet("type-options")]
    public async Task<List<SelectOption>> GetBusinessTypeOptionsAsync(string? type)
    {
        return await businessLogService.GetBusinessTypeOptionsAsync(type);
    }
}