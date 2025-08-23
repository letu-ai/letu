using Letu.Basis.Admin.Editions;
using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Core.Applications;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Tenants
{
    public class TenantAppService : ApplicationService, ITenantAppService
    {
        private readonly IFreeSqlRepository<Tenant> _tenantRepository;
        private readonly IFreeSqlRepository<Edition> _editionRepository;

        public TenantAppService(
            IFreeSqlRepository<Tenant> tenantRepository,
            IFreeSqlRepository<Edition> editionRepository)
        {
            _tenantRepository = tenantRepository;
            _editionRepository = editionRepository;
        }

        public async Task AddTenantAsync(TenantCreateOrUpdateInput dto)
        {
            if (await _tenantRepository.Select.AnyAsync(x => x.Name == dto.Name))
            {
                throw new BusinessException(message: $"租户[{dto.Name}]已存在");
            }

            var entity = new Tenant()
            {
                Name = dto.Name,
                Remark = dto.Remark,
                EditionId = dto.EditionId,
                BindDomain = dto.BindDomain,
                ExpireDate = dto.ExpireDate,
                ContactName = dto.ContactName,
                ContactPhone = dto.ContactPhone,
                AdminEmail = dto.AdminEmail,
                WebsiteName = dto.WebsiteName,
                Logo = dto.Logo,
                IcpNumber = dto.IcpNumber,
                IsActive = dto.IsActive
            };
            await _tenantRepository.InsertAsync(entity);
        }

        public async Task DeleteTenantAsync(Guid tenantId)
        {
            await _tenantRepository.DeleteAsync(x => x.Id == tenantId);
        }

        public async Task<PagedResult<TenantListOutput>> GetTenantListAsync(TenantListInput dto)
        {
            // 先查询所有的版本信息，放入字典中以提高性能
            var editionsDict = await _editionRepository.Select
                .ToListAsync(x => new { x.Id, x.Name })
                .ContinueWith(t => t.Result.ToDictionary(k => k.Id, v => v.Name));

            var tenants = await _tenantRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name.Contains(dto.Keyword!))
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync();

            var items = tenants.Select(x =>
            {
                var item = ObjectMapper.Map<Tenant, TenantListOutput>(x);
                // 设置版本名称
                item.EditionName = item.EditionId.HasValue && editionsDict.ContainsKey(item.EditionId.Value)
                    ? editionsDict[item.EditionId.Value]
                    : null;
                return item;
            }).ToList();

            return new PagedResult<TenantListOutput>(dto)
            {
                TotalCount = total,
                Items = items
            };
        }

        public async Task UpdateTenantAsync(Guid id, TenantCreateOrUpdateInput dto)
        {
            var entity = await _tenantRepository.Where(x => x.Id == id).FirstAsync();
            if (entity == null)
            {
                throw new BusinessException(message: $"租户不存在");
            }

            if (await _tenantRepository.Select.AnyAsync(x => x.Id != id && x.Name == dto.Name))
            {
                throw new BusinessException(message: $"租户名称[{dto.Name}]已存在");
            }

            entity.Name = dto.Name;
            entity.Remark = dto.Remark;
            entity.EditionId = dto.EditionId;
            entity.BindDomain = dto.BindDomain;
            entity.ExpireDate = dto.ExpireDate;
            entity.ContactName = dto.ContactName;
            entity.ContactPhone = dto.ContactPhone;
            entity.AdminEmail = dto.AdminEmail;
            entity.WebsiteName = dto.WebsiteName;
            entity.Logo = dto.Logo;
            entity.IcpNumber = dto.IcpNumber;
            entity.IsActive = dto.IsActive;

            await _tenantRepository.UpdateAsync(entity);
        }
    }
}