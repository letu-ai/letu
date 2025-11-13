using Letu.Basis.Admin.DataDictionaries.Dtos;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Logging.BusinessLogs;
using Letu.Repository;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.DataDictionaries;

public class DataDictionaryAppService : BasisAppService, IDataDictionaryAppService
{
    private readonly IFreeSqlRepository<DataDictionary> dictRepository;
    private readonly IFreeSqlRepository<DataDictionaryItem> itemRepository;

    public DataDictionaryAppService(
        IFreeSqlRepository<DataDictionary> dictRepository,
        IFreeSqlRepository<DataDictionaryItem> itemRepository)
    {
        this.dictRepository = dictRepository;
        this.itemRepository = itemRepository;
    }

    [BusinessLog("数据字典", BusinessOperateType.Create, "添加数据字典{{Name}}")]
    public async Task AddDictionaryAsync(DictionaryCreateInput input)
    {
        if (await dictRepository.Select.AnyAsync(x => x.Name.ToLower() == input.Name.ToLower()))
        {
            throw HttpFriendlyException.BadRequest($"字典类型{input.Name}已存在");
        }

        var entity = new DataDictionary
        {
            DisplayName = input.DisplayName,
            IsEnabled = input.IsEnabled,
            Name = input.Name,
            Remark = input.Remark
        };

        BusinessLogManager.Current?.AddVariable("Name", input.Name);

        await dictRepository.InsertAsync(entity);
    }

    [BusinessLog("数据字典", BusinessOperateType.Delete,  "删除数据字典{{Name}}")]
    public async Task DeleteDictionaryAsync(Guid id)
    {
        var dict = await dictRepository.OneAsync(x => x.Id == id)
            ?? throw new EntityNotFoundException();

        await itemRepository.DeleteAsync(x => x.DictionaryName == dict.Name);
        await dictRepository.DeleteAsync(dict);

        BusinessLogManager.Current?.AddVariable("Name", dict.Name);
    }

    [BusinessLog("数据字典", BusinessOperateType.Delete,  "批量删除数据字典{{Names}}")]
    public async Task DeleteDictionariesAsync(Guid[] ids)
    {
        var dictNames = await dictRepository.Where(x => ids.Contains(x.Id)).ToListAsync(x => x.Name);
        itemRepository.Delete(x => dictNames.Contains(x.DictionaryName));
        await dictRepository.DeleteAsync(x => ids.Contains(x.Id));

        BusinessLogManager.Current?.AddVariable("Names", string.Join(',', dictNames));
    }

    public async Task<PagedResult<DictionaryListOutput>> GetDictionaryListAsync(DictionaryListInput input)
    {
        var rows = await dictRepository.Select
            .WhereIf(!string.IsNullOrEmpty(input.Keywords), x => x.DisplayName.Contains(input.Keywords!) || x.Name.Contains(input.Keywords!))
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(input.Current, input.PageSize)
            .ToListAsync(x => new DictionaryListOutput
            {
                DisplayName = x.DisplayName,
                Id = x.Id,
                IsEnabled = x.IsEnabled,
                Name = x.Name,
                Remark = x.Remark,
                CreationTime = x.CreationTime
            });

        return new PagedResult<DictionaryListOutput>(input)
        {
            TotalCount = total,
            Items = rows
        };
    }

    [BusinessLog("数据字典", BusinessOperateType.Update,  "更新数据字典{{Name}}")]
    public async Task UpdateDictionaryAsync(Guid id, DictionaryUpdateInput input)
    {
        var entity = await dictRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw new EntityNotFoundException(typeof(DataDictionary), id);

        ObjectMapper.Map(input, entity);
        BusinessLogManager.Current?.AddVariable("Name", entity.Name);

        await dictRepository.UpdateAsync(entity);
    }

    public Task<List<SelectOption>> GetDictionaryOptionsAsync(string name)
    {
        return itemRepository
            .Where(x => x.DictionaryName == name)
            .OrderBy(x => x.Sort)
            .ToListAsync(x => new SelectOption
            {
                Label = x.Label ?? x.Value,
                Value = x.Value,
                Disabled = !x.IsEnabled
            });
    }

    public async Task<Dictionary<string, List<SelectOption>?>> GetDictionaryOptionsBatchAsync(string[] dictNames)
    {
        // 创建结果字典
        var result = new Dictionary<string, List<SelectOption>?>();

        // 如果没有传入字典名称，直接返回空结果
        if (dictNames == null || dictNames.Length == 0)
        {
            return result;
        }

        // 一次性查询所有匹配的字典项
        var items = await itemRepository
            .Where(x => dictNames.Contains(x.DictionaryName))
            .ToListAsync();

        // 按字典名称分组，并转换为 SelectOption 列表
        foreach (var dictName in dictNames)
        {
            var dictItems = items
                .Where(x => x.DictionaryName == dictName)
                .OrderBy(x => x.Sort)
                .Select(x => new SelectOption
                {
                    Label = x.Label ?? x.Value,
                    Value = x.Value,
                    Disabled = !x.IsEnabled
                })
                .ToList();

            // 如果该字典没有找到项，添加 null 或空列表
            result[dictName] = dictItems.Count > 0 ? dictItems : null;
        }

        return result;
    }


    [BusinessLog("数据字典", BusinessOperateType.Update,  "添加值{{Name}}/{{Value}}")]
    public async Task<bool> AddItemAsync(string dictName, ItemCreateOrUpdateInput input)
    {
        var isExist = await itemRepository.Select.AnyAsync(x => x.DictionaryName == dictName && x.Value == input.Value);
        if (isExist)
        {
            throw HttpFriendlyException.BadRequest($"字典值{input.Value}已存在");
        }

        var entity = ObjectMapper.Map<ItemCreateOrUpdateInput, DataDictionaryItem>(input);
        entity.DictionaryName = dictName;

        BusinessLogManager.Current?.AddVariable("Name", dictName);
        BusinessLogManager.Current?.AddVariable("Name", input.Value);

        await itemRepository.InsertAsync(entity);

        return true;
    }

    [BusinessLog("数据字典", BusinessOperateType.Delete,  "删除值{{Name}}/{{IDs}}")]
    public async Task<bool> DeleteItemAsync(string dictName, Guid[] ids)
    {
        await itemRepository.DeleteAsync(x => x.DictionaryName == dictName && ids.Contains(x.Id));

        BusinessLogManager.Current?.AddVariable("Name", dictName);
        BusinessLogManager.Current?.AddVariable("IDs", string.Join(',', ids));

        return true;
    }

    public async Task<PagedResult<ItemListOutput>> GetItemListAsync(string name, ItemListInput input)
    {
        var rows = await itemRepository.Select
            .Where(x => x.DictionaryName == name)
            .WhereIf(!string.IsNullOrEmpty(input.Keywords), x => (x.Label != null && x.Label.Contains(input.Keywords!) || x.Value.Contains(input.Keywords!)))
            .OrderBy(x => x.Sort)
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(input.Current, input.PageSize)
            .ToListAsync<ItemListOutput>();

        return new PagedResult<ItemListOutput>(total, rows);
    }

    [BusinessLog("数据字典", BusinessOperateType.Update,  "更新值{{Name}}/{{Value}} =>{NewValue}")]
    public async Task<bool> UpdateItemAsync(string dictName, Guid id, ItemCreateOrUpdateInput input)
    {
        var isExist = await itemRepository.Select.AnyAsync(x => x.DictionaryName == dictName && x.Value == input.Value && x.Id != id);

        if (isExist)
        {
            throw HttpFriendlyException.BadRequest($"字典值{input.Value}已存在");
        }

        var item = await itemRepository.OneAsync(x => x.DictionaryName == dictName && x.Id == id);
        if (item == null)
        {
            throw new HttpFriendlyException($"未找到ID为{id}的字典项");
        }

        BusinessLogManager.Current?.AddVariable("Name", dictName);
        BusinessLogManager.Current?.AddVariable("Value", item.Value);
        BusinessLogManager.Current?.AddVariable("after", input.Value);

        ObjectMapper.Map(input, item);
        await itemRepository.UpdateAsync(item);

        return true;
    }
}