using Letu.Basis.Admin.Logging.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Logging
{
    public interface ILoginLogService : IScopedDependency
    {
        /// <summary>
        /// 登录日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<LoginLogListDto>> GetLoginLogListAsync(LoginLogQueryDto dto);
    }
}