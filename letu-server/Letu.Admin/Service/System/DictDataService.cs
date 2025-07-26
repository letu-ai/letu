using Letu.Admin.Entities.System;
using Letu.Admin.IService.System;
using Letu.Admin.IService.System.Dtos;
using Letu.Core.Helpers;
using Letu.Logger;
using Letu.Repository;
using Letu.Shared.Consts;

namespace Letu.Admin.Service.System
{
    public class DictDataService : IDictDataService
    {
        private readonly IRepository<DictDataDO> _dictRepository;

        public DictDataService(IRepository<DictDataDO> dictRepository)
        {
            _dictRepository = dictRepository;
        }

        public async Task<bool> AddDictDataAsync(DictDataDto dto)
        {
            var isExist = await _dictRepository.Select.AnyAsync(x => x.Value.ToLower() == dto.Value.ToLower());
            if (isExist)
            {
                throw new BusinessException("字典值已存在");
            }
            var entity = AutoMapperHelper.Instance.Map<DictDataDto, DictDataDO>(dto);
            await _dictRepository.InsertAsync(entity);

            return true;
        }

        [AsyncLogRecord(LogRecordConsts.SysDictData, LogRecordConsts.SysDictDataDeleteSubType, "{{ids}}", LogRecordConsts.SysDictDataDeleteContent)]
        public async Task<bool> DeleteDictDataAsync(Guid[] ids)
        {
            var entity = await _dictRepository.Where(x => ids.Contains(x.Id)).FirstAsync()
                ?? throw new BusinessException("数据不存在");
            await _dictRepository.DeleteAsync(entity);

            LogRecordContext.PutVariable("ids", string.Join(',', ids));

            return true;
        }

        public async Task<PagedResult<DictDataListDto>> GetDictDataListAsync(DictDataQueryDto dto)
        {
            var rows = await _dictRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.Label), x => x.Label != null && x.Label.Contains(dto.Label!))
                .WhereIf(!string.IsNullOrEmpty(dto.DictType), x => x.DictType != null && x.DictType.Contains(dto.DictType!))
                .OrderBy(x => x.Sort).OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<DictDataListDto>();

            return new PagedResult<DictDataListDto>(total, rows);
        }

        [AsyncLogRecord(LogRecordConsts.SysDictData, LogRecordConsts.SysDictDataUpdateSubType, "{{id}}", LogRecordConsts.SysDictDataUpdateContent)]
        public async Task<bool> UpdateDictDataAsync(DictDataDto dto)
        {
            if (!dto.Id.HasValue) throw new ArgumentNullException(nameof(dto.Id));
            var entity = await _dictRepository.Where(x => x.Id == dto.Id).FirstAsync()
                ?? throw new BusinessException("数据不存在");
            var isExist = await _dictRepository.Select.AnyAsync(x => x.Value.ToLower() == dto.Value.ToLower());
            if (entity.Value.ToLower() != dto.Value.ToLower() && isExist)
            {
                throw new BusinessException("字典值已存在");
            }

            entity.Value = dto.Value;
            entity.DictType = dto.DictType;
            entity.Label = dto.Label;
            entity.Sort = dto.Sort;
            entity.Remark = dto.Remark;
            entity.IsEnabled = dto.IsEnabled;
            await _dictRepository.UpdateAsync(entity);

            LogRecordContext.PutVariable("id", entity.Id);
            LogRecordContext.PutVariable("after", entity);
            return true;
        }
    }
}