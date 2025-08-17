using Letu.Applications;
using Letu.Basis.Admin.Editions.Dtos;

namespace Letu.Basis.Admin.Editions
{
    public interface IEditionAppService
    {
        /// <summary>
        /// 新增版本
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddEditionAsync(EditionCreateOrUpdateInput dto);

        /// <summary>
        /// 版本列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<EditionListOutput>> GetEditionListAsync(EditionListInput dto);

        /// <summary>
        /// 修改版本
        /// </summary>
        /// <param name="id">版本ID</param>
        /// <param name="dto">版本信息</param>
        /// <returns></returns>
        Task<bool> UpdateEditionAsync(Guid id, EditionCreateOrUpdateInput dto);

        /// <summary>
        /// 删除版本
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        Task<bool> DeleteEditionAsync(Guid id);

        /// <summary>
        /// 获取版本下拉列表
        /// </summary>
        /// <returns>版本下拉列表数据</returns>
        Task<List<EditionInfoDto>> GetEditionSelectListAsync();
    }
} 