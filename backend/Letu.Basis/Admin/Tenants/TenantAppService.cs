using FreeSql;
using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Editions;
using Letu.Basis.Admin.Tenants.Dtos;
using Letu.Basis.Oss;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Repository;
using Microsoft.Extensions.Options;
using System.Reflection;
using Volo.Abp.Application.Services;
using Volo.Abp.BlobStoring;
using Volo.Abp.Data;
using Volo.Abp.EventBus.Distributed;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Tenants;

public class TenantAppService : ApplicationService, ITenantAppService
{
    private readonly IDistributedEventBus distributedEventBus;
    private readonly IDataSeeder dataSeeder;
    private readonly ITenantNormalizer tenantNormalizer;
    private readonly IFreeSqlRepository<Tenant> tenantRepository;
    private readonly IFreeSqlRepository<Edition> _editionRepository;
    private readonly IBlobContainer<TenantLogoBlobContainer> blobContainer;
    private readonly IOptions<TenantTableOptions> tenantTableOptions;
    private readonly IFreeSql freeSql;

    public TenantAppService(
        IDistributedEventBus distributedEventBus,
        IDataSeeder dataSeeder,
        ITenantNormalizer tenantNormalizer,
        IFreeSqlRepository<Tenant> tenantRepository,
        IFreeSqlRepository<Edition> editionRepository,
        IBlobContainer<TenantLogoBlobContainer> blobContainer,
        IOptions<TenantTableOptions> tenantTableOptions,
        IFreeSql freeSql)
    {
        this.distributedEventBus = distributedEventBus;
        this.dataSeeder = dataSeeder;
        this.tenantNormalizer = tenantNormalizer;
        this.tenantRepository = tenantRepository;
        _editionRepository = editionRepository;
        this.blobContainer = blobContainer;
        this.tenantTableOptions = tenantTableOptions;
        this.freeSql = freeSql;
    }

    public async Task AddTenantAsync(TenantCreateOrUpdateInput dto)
    {
        if (await tenantRepository.Select.AnyAsync(x => x.Name == dto.Name))
        {
            throw HttpFriendlyException.BadRequest($"租户[{dto.Name}]已存在");
        }

        var entity = new Tenant()
        {
            Name = dto.Name,
            NormalizedName = tenantNormalizer.NormalizeName(dto.Name) ?? dto.Name.ToUpperInvariant(),
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
        await tenantRepository.InsertAsync(entity);

        // 获取数据库自动生成的 TableSuffix
        int tableSuffix = entity.TableSuffix;

        if(tableSuffix > 9999)
        {
            throw HttpFriendlyException.BadRequest("租户数量超出范围，请联系管理员。");
        }

        // 创建租户表
        CreateTenantTables(tableSuffix);

        await distributedEventBus.PublishAsync(
            new TenantCreatedEto
            {
                Id = entity.Id,
                Name = entity.Name,
                Properties =
                {
                        { "AdminEmail", dto.AdminEmail },
                        { "AdminPassword", dto.AdminPassword }
                }
            });

        using (CurrentTenant.Change(entity.Id, entity.Name))
        {
            //TODO: Handle database creation?
            // TODO: Seeder might be triggered via event handler.
            await dataSeeder.SeedAsync(
                            new DataSeedContext(entity.Id)
                                .WithProperty("AdminEmail", dto.AdminEmail)
                                .WithProperty("AdminPassword", dto.AdminPassword)
                            );
        }
    }

    public async Task DeleteTenantAsync(Guid tenantId)
    {
        await tenantRepository.DeleteAsync(x => x.Id == tenantId);
    }

    public async Task<PagedResult<TenantListOutput>> GetTenantListAsync(TenantListInput dto)
    {
        // 先查询所有的版本信息，放入字典中以提高性能
        var editionsDict = await _editionRepository.Select
            .ToListAsync(x => new { x.Id, x.Name })
            .ContinueWith(t => t.Result.ToDictionary(k => k.Id, v => v.Name));

        var tenants = await tenantRepository.Select
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
        var entity = await tenantRepository.Where(x => x.Id == id).FirstAsync();
        if (entity == null)
        {
            throw HttpFriendlyException.NotFound($"租户不存在");
        }

        if (await tenantRepository.Select.AnyAsync(x => x.Id != id && x.Name == dto.Name))
        {
            throw HttpFriendlyException.BadRequest($"租户名称[{dto.Name}]已存在");
        }

        entity.Name = dto.Name;
        entity.NormalizedName = tenantNormalizer.NormalizeName(dto.Name) ?? dto.Name.ToUpperInvariant();
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

        await tenantRepository.UpdateAsync(entity);
    }


    public async Task<(Stream?, string)> GetLogoAsync(Guid id, string? logo, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrEmpty(logo))
        {
            return (null, "");
        }

        using (CurrentTenant.Change(id))
        {
            if (await blobContainer.ExistsAsync(logo, cancellationToken))
            {
                var stream = await blobContainer.GetAsync(logo, cancellationToken);
                return (stream, MimeMapper.GetContentType(logo));
            }
            else
            {
                return (null, "");
            }
        }
    }


    public async Task<string> UploadLogoAsync(Guid id, TenantLogoUploadInput input)
    {
        using (CurrentTenant.Change(id))
        {
            var fileName = $"logo{Path.GetExtension(input.File.FileName)}";
            using var stream = input.File.OpenReadStream();
            await blobContainer.SaveAsync(fileName, stream, overrideExisting: true);
            return fileName;
        }
    }

    /// <summary>
    /// 创建租户表
    /// </summary>
    /// <param name="tableSuffix">表后缀（1-9999）</param>
    private void CreateTenantTables(int tableSuffix)
    {
        var suffix = $"-T{tableSuffix:D4}"; // 格式: -T0001

        foreach (var assembly in tenantTableOptions.Value.EntityAssemblies)
        {
            var entityTypes = assembly.GetTypes()
                .Where(t => t.IsClass && !t.IsAbstract)
                .Where(t => typeof(IMultiTenant).IsAssignableFrom(t))
                .Where(t => t.GetCustomAttribute<TableAttribute>() != null);

            foreach (var entityType in entityTypes)
            {
                var tableAttr = entityType.GetCustomAttribute<TableAttribute>()!;
                var newTableName = tableAttr.Name + suffix;

                freeSql.CodeFirst.SyncStructure(entityType, newTableName);
                Logger.LogInformation("创建租户表：{newTableName}", newTableName);
            }
        }
    }
}