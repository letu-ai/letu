using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.DataDictionary
{
    public interface IDataDictionaryAppService
    {
        Task AddDictTypeAsync(TypeCreateOrUpdateInput dto);

        Task<PagedResult<TypeListOutput>> GetDictTypeListAsync(TypeListInput dto);

        Task UpdateDictTypeAsync(Guid id, TypeCreateOrUpdateInput dto);

        Task DeleteDictTypeAsync(string dictType);

        Task<List<SelectOption>> GetDictDataOptionsAsync(string type);

        Task DeleteDictTypesAsync(Guid[] ids);

        /// <summary>
        /// 新增字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> AddDictDataAsync(ItemCreateOrUpdateInput dto);

        /// <summary>
        /// 字典分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<ItemListOutput>> GetDataItemListAsync(ItemListInput dto);

        /// <summary>
        /// 修改字典
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateDictDataAsync(Guid id, ItemCreateOrUpdateInput dto);

        /// <summary>
        /// 删除字典
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        Task<bool> DeleteDictDataAsync(Guid[] ids);
    }
}