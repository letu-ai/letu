using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings;

public interface ISecurityLogAppService
{
    /// <summary>
    /// 登录日志分页列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<PagedResult<SecurityLogListOutput>> GetSecurityLogListAsync(SecurityLogListInput input);
}