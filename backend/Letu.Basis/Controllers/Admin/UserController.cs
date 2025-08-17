using Letu.Applications;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.Permissions;

using Letu.Logging;
using Letu.Shared.Consts;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.User.Default)]
    [ApiController]
    [Route("api/admin/users")]
    public class UserController : ControllerBase
    {
        private readonly IUserAppService _userService;

        public UserController(IUserAppService userService)
        {
            _userService = userService;
        }

        /// <summary>
        /// 新增用户
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.User.Create)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        [ApiAccessLog(operateName: "新增用户", operateType: [OperateType.Create], reponseEnable: true)]
        public async Task AddUserAsync([FromBody] UserCreateOrUpdateInput dto)
        {
            await _userService.AddUserAsync(dto);
        }

        /// <summary>
        /// 用户分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [ApiAccessLog(operateName: "用户分页列表")]
        public async Task<PagedResult<UserListOutput>> GetUserListAsync([FromQuery] UserListInput dto)
        {
            return await _userService.GetUserListAsync(dto);
        }

        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id:Guid}")]
        [Authorize(BasisPermissions.User.Delete)]
        public async Task DeleteUserAsync(Guid id)
        {
            await _userService.DeleteUserAsync(id);
        }

        /// <summary>
        /// 分配角色
        /// </summary>
        /// <param name="id"></param>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPost("{id:Guid}/assign-role")]
        [Authorize(BasisPermissions.User.Update)]
        [ApiAccessLog(operateName: "分配角色", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task AssignRoleAsync(Guid id, [FromBody] AssignRoleDto input)
        {
            await _userService.AssignRoleAsync(id, input);
        }

        /// <summary>
        /// 切换用户启用状态
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpPut("{id:Guid}/enabled")]
        [Authorize(BasisPermissions.User.Update)]
        [ApiAccessLog(operateName: "切换用户启用状态", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task SwitchUserEnabledStatusAsync(Guid id)
        {
            await _userService.SwitchUserEnabledStatusAsync(id);
        }

        /// <summary>
        /// 获取指定用户角色
        /// </summary>
        /// <param name="uid"></param>
        /// <returns></returns>
        [HttpGet("{uid:Guid}/roles")]
        public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
        {
            return await _userService.GetUserRoleIdsAsync(uid);
        }

        /// <summary>
        /// 重置用户密码
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpPut("reset-password")]
        [Authorize(BasisPermissions.User.Update)]
        [ApiAccessLog(operateName: "重置用户密码", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task ResetUserPasswordAsync([FromBody] ResetUserPwdDto dto)
        {
            await _userService.ResetUserPasswordAsync(dto);
        }

        /// <summary>
        /// 用户简单信息查询
        /// </summary>
        /// <param name="keyword"></param>
        /// <returns></returns>
        [HttpGet("simple")]
        public async Task<List<UserSimpleInfoDto>> GetUserSimpleInfosAsync(string? keyword)
        {
            return await _userService.GetUserSimpleInfosAsync(keyword);
        }
    }
}