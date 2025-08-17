using Letu.Applications;
using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Permissions;

using Letu.Logging;
using Letu.Shared.Consts;
using Letu.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.Role.Default)]
    [ApiController]
    [Route("/api/admin/roles")]
    public class RoleController : ControllerBase
    {
        private readonly IRoleAppService _roleService;

        public RoleController(IRoleAppService roleService)
        {
            _roleService = roleService;
        }

        /// <summary>
        /// 新增角色
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.Role.Create)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task AddRoleAsync([FromBody] RoleCreateOrUpdateInput dto)
        {
            await _roleService.AddRoleAsync(dto);
        }

        /// <summary>
        /// 角色分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<PagedResult<RoleListOutput>> GetRoleListAsync([FromQuery] RoleListInput dto)
        {
            return await _roleService.GetRoleListAsync(dto);
        }

        /// <summary>
        /// 修改角色
        /// </summary>
        /// <param name="id"></param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("{id:Guid}")]
        [Authorize(BasisPermissions.Role.Update)]
        [ApiAccessLog(operateName: "修改角色", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task UpdateRoleAsync(Guid id, [FromBody] RoleCreateOrUpdateInput dto)
        {
            await _roleService.UpdateRoleAsync(id, dto);
        }

        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:Guid}")]
        [Authorize(BasisPermissions.Role.Delete)]
        [ApiAccessLog(operateName: "删除角色", operateType: [OperateType.Delete], reponseEnable: true)]
        public async Task DeleteRoleAsync(Guid id)
        {
            await _roleService.DeleteRoleAsync(id);
        }

        /// <summary>
        /// 分配菜单
        /// </summary>
        /// <param name="id"></param>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("{id:Guid}/menus")]
        [ApiAccessLog(operateName: "分配菜单权限", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task AssignMenuAsync(Guid id, [FromBody] AssignMenuDto dto)
        {
            dto.RoleId = id; // 确保角色ID一致
            await _roleService.AssignMenuAsync(dto);
        }

        /// <summary>
        /// 获取角色选项
        /// </summary>
        /// <returns></returns>
        [HttpGet("options")]
        public async Task<List<AppOption>> GetRoleOptionsAsync()
        {
            return await _roleService.GetRoleOptionsAsync();
        }

        /// <summary>
        /// 获取指定角色菜单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id:Guid}/menus")]
        public async Task<Guid[]> GetRoleMenuIdsAsync(Guid id)
        {
            return await _roleService.GetRoleMenuIdsAsync(id);
        }
    }
}