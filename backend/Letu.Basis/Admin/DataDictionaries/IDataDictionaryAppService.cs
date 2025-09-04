using Letu.Basis.Admin.DataDictionaries.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.DataDictionaries;

public interface IDataDictionaryAppService
{
    Task AddDictionaryAsync(DictionaryCreateInput input);

    Task<PagedResult<DictionaryListOutput>> GetDictionaryListAsync(DictionaryListInput input);

    Task UpdateDictionaryAsync(Guid id, DictionaryUpdateInput input);

    Task DeleteDictionaryAsync(Guid id);

    Task DeleteDictionariesAsync(Guid[] ids);

    Task<List<SelectOption>> GetDictionaryOptionsAsync(string name);
    
    Task<Dictionary<string, List<SelectOption>?>> GetDictionaryOptionsBatchAsync(string[] dictNames);

    /// <summary>
    /// 新增字典项
    /// </summary>
    /// <param name="dictName"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<bool> AddItemAsync(string dictName, ItemCreateOrUpdateInput input);

    /// <summary>
    /// 字典项分页列表
    /// </summary>
    /// <param name="dictName"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<PagedResult<ItemListOutput>> GetItemListAsync(string dictName, ItemListInput input);

    /// <summary>
    /// 修改字典项
    /// </summary>
    /// <param name="id"></param>
    /// <param name="dictName"></param>
    /// <param name="input"></param>
    /// <returns></returns>
    Task<bool> UpdateItemAsync(string dictName, Guid id, ItemCreateOrUpdateInput input);

    /// <summary>
    /// 删除字典项
    /// </summary>
    /// <param name="dictName"></param>
    /// <param name="ids"></param>
    /// <returns></returns>
    Task<bool> DeleteItemAsync(string dictName, Guid[] ids);
}