using Letu.Applications;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Shared.Models;

namespace Letu.Basis.Admin.Loggings
{
    public interface IBusinessLogAppService
    {
        /// <summary>
        /// 业务日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<BusinessLogListDto>> GetBusinessLogListAsync(BusinessLogQueryDto dto);

        /// <summary>
        /// 获取所有业务类型选项
        /// </summary>
        /// <param name="type">业务类型模糊匹配</param>
        /// <returns></returns>
        Task<List<AppOption>> GetBusinessTypeOptionsAsync(string? type);
    }
}