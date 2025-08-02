using Letu.Applications;
using Letu.Basis.Admin.Tenants;
using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Core.Attributes;
using Letu.Logging;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [MustMainPower]
    [Route("api/admin/tenants")]
    public class TenantController : ControllerBase
    {
        private readonly ITenantAppService tenantService;

        public TenantController(ITenantAppService tenantService)
        {
            this.tenantService = tenantService;
        }

        [HttpPost]
        [HasPermission("Sys.Tenant.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        [ApiAccessLog(operateName: "添加租户", operateType: [OperateType.Create], reponseEnable: true)]
        public async Task AddTenantAsync([FromBody] TenantCreateOrUpdateInput dto)
        {
            await tenantService.AddTenantAsync(dto);
        }

        /// <summary>
        /// 分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Sys.Tenant.List")]
        public async Task<PagedResult<TenantListOutput>> GetTenantListAsync([FromQuery] TenantListInput dto)
        {
            return await tenantService.GetTenantListAsync(dto);
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [HasPermission("Sys.Tenant.Update")]
        [ApiAccessLog(operateName: "修改租户", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task UpdateTenantAsync(Guid id, [FromBody] TenantCreateOrUpdateInput input)
        {
            await tenantService.UpdateTenantAsync(id, input);
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:Guid}")]
        [HasPermission("Sys.Tenant.Delete")]
        [ApiAccessLog(operateName: "删除租户", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteTenantAsync(Guid id)
        {
            await tenantService.DeleteTenantAsync(id);
        }
    }
}