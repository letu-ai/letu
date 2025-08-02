using Letu.Applications;
using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Tenants
{
    public class TenantAppService : ApplicationService, ITenantAppService
    {
        private readonly IFreeSqlRepository<Tenant> tenantRepository;

        public TenantAppService(IFreeSqlRepository<Tenant> tenantRepository)
        {
            this.tenantRepository = tenantRepository;
        }

        public async Task AddTenantAsync(TenantCreateOrUpdateInput input)
        {
            if (await tenantRepository.Select.AnyAsync(x => x.Name == input.Name))
            {
                throw new BusinessException($"租户名称[{input.Name}]已存在");
            }

            var entity = new Tenant()
            {
                Name = input.Name,
                Remark = input.Remark,
                Domain = input.Domain,
            };
            await tenantRepository.InsertAsync(entity);
        }

        public async Task DeleteTenantAsync(Guid tenantId)
        {
            await tenantRepository.DeleteAsync(x => x.Id == tenantId);
        }

        public async Task<PagedResult<TenantListOutput>> GetTenantListAsync(TenantListInput dto)
        {
            var items = await tenantRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name.Contains(dto.Keyword!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<TenantListOutput>();
            return new PagedResult<TenantListOutput>(dto)
            {
                TotalCount = total,
                Items = items
            };
        }

        public async Task UpdateTenantAsync(Guid id, TenantCreateOrUpdateInput input)
        {
            var entity = await tenantRepository.Where(x => x.Id == id).FirstAsync();
            if (entity == null)
            {
                throw new BusinessException(message: $"租户不存在");
            }

            if (await tenantRepository.Select.AnyAsync(x => x.Id != id && x.Name == input.Name))
            {
                throw new BusinessException(message: $"租户名称[{input.Name}]已存在");
            }

            entity.Name = input.Name;
            entity.Remark = input.Remark;
            entity.Domain = input.Domain;

            await tenantRepository.UpdateAsync(entity);
        }
    }
}