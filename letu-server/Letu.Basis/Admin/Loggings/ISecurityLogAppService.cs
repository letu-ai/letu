using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Loggings
{
    public interface ISecurityLogAppService : IScopedDependency
    {
        /// <summary>
        /// 登录日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<LoginLogListDto>> GetLoginLogListAsync(LoginLogQueryDto dto);
    }
}