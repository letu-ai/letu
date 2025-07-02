using Fancyx.Admin.IService.System;
using Fancyx.Admin.IService.System.Dtos;
using Fancyx.Core.Attributes;
using Fancyx.Shared.Consts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Fancyx.Admin.Controllers.System
{
    [Authorize]
    [ApiController]
    [Route("api/role")]
    public class RoleController : ControllerBase
    {
        private readonly IRoleService _roleService;

        public RoleController(IRoleService roleService)
        {
            _roleService = roleService;
        }

        /// <summary>
        /// 新增角色
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("add")]
        [HasPermission("Sys.Role.Add")]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task<AppResponse<bool>> AddRoleAsync([FromBody] RoleDto dto)
        {
            await _roleService.AddRoleAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 角色分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("list")]
        [HasPermission("Sys.Role.List")]
        public async Task<AppResponse<PagedResult<RoleListDto>>> GetRoleListAsync([FromQuery] RoleQueryDto dto)
        {
            var data = await _roleService.GetRoleListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 修改角色
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("update")]
        [HasPermission("Sys.Role.Update")]
        public async Task<AppResponse<bool>> UpdateRoleAsync([FromBody] RoleDto dto)
        {
            await _roleService.UpdateRoleAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 删除角色
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("delete/{id:Guid}")]
        [HasPermission("Sys.Role.Delete")]
        public async Task<AppResponse<bool>> DeleteRoleAsync(Guid id)
        {
            await _roleService.DeleteRoleAsync(id);
            return Result.Ok();
        }

        /// <summary>
        /// 分配菜单
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("assignMenu")]
        [HasPermission("Sys.Role.AssignMenu")]
        public async Task<AppResponse<bool>> AssignMenuAsync([FromBody] AssignMenuDto dto)
        {
            await _roleService.AssignMenuAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 获取角色
        /// </summary>
        /// <returns></returns>
        [HttpGet("options")]
        public async Task<AppResponse<List<AppOption>>> GetRoleOptionsAsync()
        {
            var data = await _roleService.GetRoleOptionsAsync();
            return Result.Data(data);
        }

        /// <summary>
        /// 获取指定角色菜单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("menus/{id:Guid}")]
        public async Task<AppResponse<Guid[]>> GetRoleMenuIdsAsync(Guid id)
        {
            var data = await _roleService.GetRoleMenuIdsAsync(id);
            return Result.Data(data);
        }

        /// <summary>
        /// 分配数据
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost("assignData")]
        [HasPermission("Sys.Role.AssignData")]
        public async Task<AppResponse<bool>> AssignDataAsync([FromBody] AssignDataDto dto)
        {
            await _roleService.AssignDataAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 获取角色数据权限
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("rolePowerData")]
        [HasPermission("Sys.Role.AssignData")]
        public async Task<AppResponse<AssignDataResultDto>> GetRolePowerDataAsync(Guid id)
        {
            var data = await _roleService.GetRolePowerDataAsync(id);
            return Result.Data(data);
        }
    }
}