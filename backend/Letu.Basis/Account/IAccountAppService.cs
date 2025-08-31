using Letu.Basis.Account.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Account
{
    public interface IAccountAppService
    {
      
        /// <summary>
        /// 修改个人基本信息
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateUserInfoAsync(UserInfoUpdateInput dto);

        /// <summary>
        /// 修改个人密码
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> ChangePasswordAsync(ChangePasswordInput dto);

        /// <summary>
        /// 获取个人登录日志列表
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<PagedResult<SecurityLogListDto>> GetSecurityLogsAsync(SecurityLogQueryInput input);

        /// <summary>
        /// 获取个人登录统计信息
        /// </summary>
        /// <returns></returns>
        Task<SecurityLogStatsDto> GetSecurityLogStatsAsync();
    }
}