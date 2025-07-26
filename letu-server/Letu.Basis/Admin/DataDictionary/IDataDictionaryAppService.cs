using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.DataDictionary
{
    public interface IDataDictionaryAppService : IScopedDependency
    {
        Task AddDictTypeAsync(DictTypeDto dto);

        Task<PagedResult<DictTypeResultDto>> GetDictTypeListAsync(DictTypeSearchDto dto);

        Task UpdateDictTypeAsync(DictTypeDto dto);

        Task DeleteDictTypeAsync(string dictType);

        Task<List<AppOption>> GetDictDataOptionsAsync(string type);

        Task DeleteDictTypesAsync(Guid[] ids);

        /// <summary>
        /// 新增字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddDictDataAsync(DictDataDto dto);

        /// <summary>
        /// 字典分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<DictDataListDto>> GetDictDataListAsync(DictDataQueryDto dto);

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateDictDataAsync(DictDataDto dto);

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        Task<bool> DeleteDictDataAsync(Guid[] ids);
    }
}