using Letu.Admin.IService.System;
using Letu.Admin.IService.System.Dtos;
using Letu.Core.Attributes;
using Letu.Logger;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Admin.Controllers.System
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ConfigController : ControllerBase
    {
        private readonly IConfigService _configService;

        public ConfigController(IConfigService configService)
        {
            _configService = configService;
        }

        [HttpPost("Add")]
        [HasPermission("Sys.Config.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task<AppResponse<bool>> AddConfigAsync([FromBody] ConfigDto dto)
        {
            await _configService.AddConfigAsync(dto);
            return Result.Data(true);
        }

        [HttpGet("List")]
        [HasPermission("Sys.Config.List")]
        public async Task<AppResponse<PagedResult<ConfigListDto>>> GetConfigListAsync([FromQuery] ConfigQueryDto dto)
        {
            var data = await _configService.GetConfigListAsync(dto);
            return Result.Data(data);
        }

        [HttpPut("Update")]
        [HasPermission("Sys.Config.Update")]
        [ApiAccessLog(operateName: "修改配置", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task<AppResponse<bool>> UpdateConfigAsync(ConfigDto dto)
        {
            await _configService.UpdateConfigAsync(dto);
            return Result.Data(true);
        }

        [HttpDelete("Delete/{id}")]
        [HasPermission("Sys.Config.Delete")]
        [ApiAccessLog(operateName: "删除配置", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task<AppResponse<bool>> DeleteConfigAsync(Guid id)
        {
            await _configService.DeleteConfigAsync(id);
            return Result.Data(true);
        }
    }
}