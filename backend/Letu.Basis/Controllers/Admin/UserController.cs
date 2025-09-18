using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.Permissions;
using Letu.Basis.Personal.Profiles;
using Letu.Core.Applications;
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
        private readonly IUserAppService userService;

        public UserController(IUserAppService userService)
        {
            this.userService = userService;
        }

        /// <summary>
        /// 新增用户
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPost]
        [Authorize(BasisPermissions.User.Create)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        [ApiAccessLog(operateName: "新增用户", operateType: [OperateType.Create], reponseEnable: true)]
        public async Task AddUserAsync([FromBody] UserCreateInput input)
        {
            await userService.AddUserAsync(input);
        }

        [HttpPut("{id}")]
        [Authorize(BasisPermissions.User.Update)]
        [EnableRateLimiting(RateLimiterConsts.DebouncePolicy)]
        public async Task UpdateUserAsync(Guid id, [FromBody] UserUpdateInput input)
        {
            await userService.UpdateUserAsync(id, input);
        }

        /// <summary>
        /// 用户分页列表
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpGet]
        [ApiAccessLog(operateName: "用户分页列表")]
        public async Task<PagedResult<UserListOutput>> GetUserListAsync([FromQuery] UserListInput input)
        {
            return await userService.GetUserListAsync(input);
        }

        /// <summary>
        /// 获取用户头像
        /// </summary>
        /// <param name="avatar"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        [HttpGet("avatars/{*avatar}")]
        public async Task<IActionResult> GetAvatarAsync(string avatar, CancellationToken cancellationToken = default)
        {
            try
            {
                var (stream, contentType) = await userService.GetAvatarAsync(avatar, cancellationToken);
                if (stream == null)
                {
                    return NotFound();
                }

                return File(stream, contentType, enableRangeProcessing: true);
            }
            catch (OperationCanceledException)
            {
                // 客户端取消请求，返回204 No Content
                return NoContent();
            }
            catch
            {
                throw;
            }
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
            await userService.DeleteUserAsync(id);
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
            await userService.AssignRoleAsync(id, input);
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
            await userService.SwitchUserEnabledStatusAsync(id);
        }

        /// <summary>
        /// 获取指定用户角色
        /// </summary>
        /// <param name="uid"></param>
        /// <returns></returns>
        [HttpGet("{uid:Guid}/roles")]
        public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
        {
            return await userService.GetUserRoleIdsAsync(uid);
        }

        /// <summary>
        /// 重置用户密码
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        [HttpPut("reset-password")]
        [Authorize(BasisPermissions.User.Update)]
        [ApiAccessLog(operateName: "重置用户密码", operateType: [OperateType.Update], reponseEnable: true)]
        public async Task ResetUserPasswordAsync([FromBody] ResetUserPwdDto input)
        {
            await userService.ResetUserPasswordAsync(input);
        }

        /// <summary>
        /// 根据用户ID批量获取用户信息（用于编辑时回显）
        /// </summary>
        /// <param name="userIds">用户ID列表</param>
        /// <returns></returns>
        [HttpPost("by-ids")]
        public async Task<List<SelectOption>> GetEmployeesByUserIdsAsync([FromBody] List<Guid> userIds)
        {
            return await userService.GetUserSelectOptionsByIdsAsync(userIds);
        }


        /// <summary>
        /// 用户简单信息查询
        /// </summary>
        /// <param name="keyword"></param>
        /// <returns></returns>
        [HttpGet("select-options")]
        public async Task<List<SelectOption>> GetUserSelectOptionsAsync(string? keyword)
        {
            return await userService.GetUserSelectOptionsAsync(keyword);
        }
    }
}