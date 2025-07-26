using Letu.Basis.Admin.DataDictionary.Dtos;
using Letu.Logger;
using Letu.Repository;
using Letu.Shared.Consts;

namespace Letu.Basis.Admin.DataDictionary;

public class DictTypeService : IDictTypeService
{
    private readonly IRepository<DictionaryType> _dictTypeRepository;
    private readonly IRepository<DictionaryItem> _dictDataRepository;

    public DictTypeService(IRepository<DictionaryType> dictTypeRepository, IRepository<DictionaryItem> dictDataRepository)
    {
        _dictTypeRepository = dictTypeRepository;
        _dictDataRepository = dictDataRepository;
    }

    [AsyncLogRecord(LogRecordConsts.SysDictType, LogRecordConsts.SysDictAddSubType, "{{dict.Id}}", LogRecordConsts.SysDictAddContent)]
    public async Task AddDictTypeAsync(DictTypeDto dto)
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

        LogRecordContext.PutVariable("dict", entity);

        await _dictTypeRepository.InsertAsync(entity);
    }

    [AsyncLogRecord(LogRecordConsts.SysDictType, LogRecordConsts.SysDictDeleteSubType, "{{dict.Id}}", LogRecordConsts.SysDictDeleteContent)]
    public async Task DeleteDictTypeAsync(string dictType)
    {
        var dict = await _dictDataRepository.OneAsync(x => x.DictType.ToLower() == dictType.ToLower()) ?? throw new EntityNotFoundException();
        await _dictDataRepository.DeleteAsync(x => x.DictType == dictType);
        await _dictTypeRepository.DeleteAsync(x => x.DictType == dictType);

        LogRecordContext.PutVariable("dict", dict);
    }

    public async Task<PagedResult<DictTypeResultDto>> GetDictTypeListAsync(DictTypeSearchDto dto)
    {
        var rows = await _dictTypeRepository.Select
            .WhereIf(!string.IsNullOrEmpty(dto.Name), x => x.Name.Contains(dto.Name!))
            .WhereIf(!string.IsNullOrEmpty(dto.DictType), x => x.DictType.Contains(dto.DictType!))
            .OrderByDescending(x => x.CreationTime)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync(x => new DictTypeResultDto
            {
                Name = x.Name,
                Id = x.Id,
                IsEnabled = x.IsEnabled,
                DictType = x.DictType,
                Remark = x.Remark,
                CreationTime = x.CreationTime
            });
        return new PagedResult<DictTypeResultDto>(dto)
        {
            TotalCount = total,
            Items = rows
        };
    }

    public async Task UpdateDictTypeAsync(DictTypeDto dto)
    {
        var entity = await _dictTypeRepository.Where(x => x.Id == dto.Id).FirstAsync();
        if (!entity.DictType.Equals(dto.DictType, StringComparison.CurrentCultureIgnoreCase) && await _dictTypeRepository.Select.AnyAsync(x => x.DictType.ToLower() == dto.DictType.ToLower()))
        {
            throw new BusinessException(message: "字典类型已存在");
        }

        entity.Name = dto.Name;
        entity.IsEnabled = dto.IsEnabled;
        entity.DictType = dto.DictType;
        entity.Remark = dto.Remark;

        await _dictTypeRepository.UpdateAsync(entity);
    }

    public Task<List<AppOption>> GetDictDataOptionsAsync(string type)
    {
        return _dictDataRepository
            .Where(x => x.DictType == type)
            .OrderBy(x => x.Sort)
            .ToListAsync(x => new AppOption(x.Label, x.Value));
    }

    [AsyncLogRecord(LogRecordConsts.SysDictType, LogRecordConsts.SysDictBatchDeleteSubType, "{{ids}}", LogRecordConsts.SysDictBatchDeleteContent)]
    public async Task DeleteDictTypesAsync(Guid[] ids)
    {
        var dictTypes = await _dictTypeRepository.Where(x => ids.Contains(x.Id)).ToListAsync(x => x.DictType);
        _dictDataRepository.Delete(x => dictTypes.Contains(x.DictType));
        await _dictTypeRepository.DeleteAsync(x => ids.Contains(x.Id));

        LogRecordContext.PutVariable("ids", string.Join(',', ids));
    }
}