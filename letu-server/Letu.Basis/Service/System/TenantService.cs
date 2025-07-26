using Letu.Basis.Entities.System;
using Letu.Basis.IService.System;
using Letu.Basis.IService.System.Dtos;
using Letu.Repository;

namespace Letu.Basis.Service.System
{
    public class TenantService : ITenantService
    {
        private readonly IRepository<TenantDO> _tenantRepository;

        public TenantService(IRepository<TenantDO> tenantRepository)
        {
            _tenantRepository = tenantRepository;
        }

        public async Task AddTenantAsync(TenantDto dto)
        {
            if (await _tenantRepository.Select.AnyAsync(x => x.TenantId.ToLower() == dto.TenantId.ToLower()))
            {
                throw new BusinessException($"租户标识[{dto.TenantId}]已存在");
            }

            var entity = new TenantDO()
            {
                Name = dto.Name,
                TenantId = dto.TenantId,
                Remark = dto.Remark,
                Domain = dto.Domain,
            };
            await _tenantRepository.InsertAsync(entity);
        }

        public async Task DeleteTenantAsync(Guid tenantId)
        {
            await _tenantRepository.DeleteAsync(x => x.Id == tenantId);
        }

        public async Task<PagedResult<TenantResultDto>> GetTenantListAsync(TenantSearchDto dto)
        {
            var items = await _tenantRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name.Contains(dto.Keyword!) || x.TenantId.Contains(dto.Keyword!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<TenantResultDto>();
            return new PagedResult<TenantResultDto>(dto)
            {
                TotalCount = total,
                Items = items
            };
        }

        public async Task UpdateTenantAsync(TenantDto dto)
        {
            var entity = await _tenantRepository.Where(x => x.Id == dto.Id).FirstAsync();

            var tenantIdLower = dto.TenantId.ToLower();
            if (await _tenantRepository.Select.AnyAsync(x => x.TenantId.ToLower() == tenantIdLower) 
                && !tenantIdLower.Equals(entity.TenantId, StringComparison.CurrentCultureIgnoreCase))
            {
                throw new BusinessException($"租户标识[{dto.TenantId}]已存在");
            }

            entity.Name = dto.Name;
            entity.TenantId = dto.TenantId;
            entity.Remark = dto.Remark;
            entity.Domain = dto.Domain;

            await _tenantRepository.UpdateAsync(entity);
        }
    }
}