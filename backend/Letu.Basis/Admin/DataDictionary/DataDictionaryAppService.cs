using Letu.Applications;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Logging;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Models;
using Volo.Abp;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.DataDictionary;

public class DataDictionaryAppService : BasisAppService, IDataDictionaryAppService
{
    private readonly IFreeSqlRepository<DictionaryType> _dictTypeRepository;
    private readonly IFreeSqlRepository<DictionaryItem> _dictDataRepository;
    private readonly IOperationLogManager operationLogManager;

    public DataDictionaryAppService(
        IFreeSqlRepository<DictionaryType> dictTypeRepository,
        IFreeSqlRepository<DictionaryItem> dictDataRepository,
        IOperationLogManager operationLogManager)
    {
        _dictTypeRepository = dictTypeRepository;
        _dictDataRepository = dictDataRepository;
        this.operationLogManager = operationLogManager;
    }

    [OperationLog(LogRecordConsts.SysDictType, LogRecordConsts.SysDictAddSubType, "{{dict.Id}}", LogRecordConsts.SysDictAddContent)]
    public async Task AddDictTypeAsync(TypeCreateOrUpdateInput dto)
    {
        if (await _dictTypeRepository.Select.AnyAsync(x => x.DictType.ToLower() == dto.DictType.ToLower()))
        {
            throw new BusinessException(message: "字典类型已存在");
        }

        var entity = new DictionaryType
        {
            Name = dto.Name,
            IsEnabled = dto.IsEnabled,
            DictType = dto.DictType,
            Remark = dto.Remark
        };

        operationLogManager.Current?.AddVariable("dict", entity);

        await _dictTypeRepository.InsertAsync(entity);
    }

    [OperationLog(LogRecordConsts.SysDictType, LogRecordConsts.SysDictDeleteSubType, "{{dict.Id}}", LogRecordConsts.SysDictDeleteContent)]
    public async Task DeleteDictTypeAsync(string dictType)
    {
        var dict = await _dictDataRepository.OneAsync(x => x.DictType.ToLower() == dictType.ToLower()) ?? throw new EntityNotFoundException();
        await _dictDataRepository.DeleteAsync(x => x.DictType == dictType);
        await _dictTypeRepository.DeleteAsync(x => x.DictType == dictType);

        operationLogManager.Current?.AddVariable("dict", dict);
    }

    public async Task<PagedResult<TypeListOutput>> GetDictTypeListAsync(TypeListInput dto)
    {
        var rows = await _dictTypeRepository.Select
            .WhereIf(!string.IsNullOrEmpty(dto.Name), x => x.Name.Contains(dto.Name!))
            .WhereIf(!string.IsNullOrEmpty(dto.DictType), x => x.DictType.Contains(dto.DictType!))
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync(x => new TypeListOutput
            {
                Name = x.Name,
                Id = x.Id,
                IsEnabled = x.IsEnabled,
                DictType = x.DictType,
                Remark = x.Remark,
                CreationTime = x.CreationTime
            });
        return new PagedResult<TypeListOutput>(dto)
        {
            TotalCount = total,
            Items = rows
        };
    }

    public async Task UpdateDictTypeAsync(Guid id, TypeCreateOrUpdateInput input)
    {
        var entity = await _dictTypeRepository.Where(x => x.Id == id).FirstAsync() 
            ?? throw new EntityNotFoundException(typeof(DictionaryType), id);
            
        if (!entity.DictType.Equals(input.DictType, StringComparison.CurrentCultureIgnoreCase) && await _dictTypeRepository.Select.AnyAsync(x => x.DictType.ToLower() == input.DictType.ToLower()))
        {
            throw new BusinessException(message: "字典类型已存在");
        }

        ObjectMapper.Map(input, entity);

        await _dictTypeRepository.UpdateAsync(entity);
    }

    public Task<List<AppOption>> GetDictDataOptionsAsync(string type)
    {
        return _dictDataRepository
            .Where(x => x.DictType == type)
            .OrderBy(x => x.Sort)
            .ToListAsync(x => new AppOption(x.Label, x.Value));
    }

    [OperationLog(LogRecordConsts.SysDictType, LogRecordConsts.SysDictBatchDeleteSubType, "{{ids}}", LogRecordConsts.SysDictBatchDeleteContent)]
    public async Task DeleteDictTypesAsync(Guid[] ids)
    {
        var dictTypes = await _dictTypeRepository.Where(x => ids.Contains(x.Id)).ToListAsync(x => x.DictType);
        _dictDataRepository.Delete(x => dictTypes.Contains(x.DictType));
        await _dictTypeRepository.DeleteAsync(x => ids.Contains(x.Id));

        operationLogManager.Current?.AddVariable("ids", string.Join(',', ids));
    }


    public async Task<bool> AddDictDataAsync(ItemCreateOrUpdateInput dto)
    {
        var isExist = await _dictDataRepository.Select.AnyAsync(x => x.Value.ToLower() == dto.Value.ToLower());
        if (isExist)
        {
            throw new BusinessException(message: "字典值已存在");
        }
        var entity = ObjectMapper.Map<ItemCreateOrUpdateInput, DictionaryItem>(dto);
        await _dictDataRepository.InsertAsync(entity);

        return true;
    }

    [OperationLog(LogRecordConsts.SysDictData, LogRecordConsts.SysDictDataDeleteSubType, "{{ids}}", LogRecordConsts.SysDictDataDeleteContent)]
    public async Task<bool> DeleteDictDataAsync(Guid[] ids)
    {
        var entity = await _dictDataRepository.Where(x => ids.Contains(x.Id)).FirstAsync()
            ?? throw new BusinessException(message: "数据不存在");
        await _dictDataRepository.DeleteAsync(entity);

        operationLogManager.Current?.AddVariable("ids", string.Join(',', ids));

        return true;
    }

    public async Task<PagedResult<ItemListOutput>> GetDataItemListAsync(ItemListInput dto)
    {
        var rows = await _dictDataRepository.Select
            .WhereIf(!string.IsNullOrEmpty(dto.Label), x => x.Label != null && x.Label.Contains(dto.Label!))
            .WhereIf(!string.IsNullOrEmpty(dto.DictType), x => x.DictType != null && x.DictType.Contains(dto.DictType!))
            .OrderBy(x => x.Sort).OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync<ItemListOutput>();

        return new PagedResult<ItemListOutput>(total, rows);
    }

    [OperationLog(LogRecordConsts.SysDictData, LogRecordConsts.SysDictDataUpdateSubType, "{{id}}", LogRecordConsts.SysDictDataUpdateContent)]
    public async Task<bool> UpdateDictDataAsync(Guid id, ItemCreateOrUpdateInput input)
    {
        var entity = await _dictDataRepository.Where(x => x.Id == id).FirstAsync() ?? throw new EntityNotFoundException(typeof(DictionaryItem), id);
        var isExist = await _dictDataRepository.Select.AnyAsync(x => x.Value.ToLower() == input.Value.ToLower());
        if (entity.Value.ToLower() != input.Value.ToLower() && isExist)
        {
            throw new BusinessException(message: "字典值已存在");
        }
        ObjectMapper.Map(input, entity);
        await _dictDataRepository.UpdateAsync(entity);

        operationLogManager.Current?.AddVariable("id", entity.Id);
        operationLogManager.Current?.AddVariable("after", entity);
        return true;
    }
}