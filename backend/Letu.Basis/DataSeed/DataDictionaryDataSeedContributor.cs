using Letu.Basis.Admin.DataDictionaries;
using Letu.Repository;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.DataSeed;

public class DataDictionaryDataSeedContributor : IDataSeedContributor, ITransientDependency
{
    private readonly ICurrentTenant currentTenant;
    private readonly IFreeSqlRepository<DataDictionary> dictionaryRepository;
    private readonly IFreeSqlRepository<DataDictionaryItem> itemRepository;

    public DataDictionaryDataSeedContributor(
        IFreeSqlRepository<DataDictionary> dictionaryRepository,
        IFreeSqlRepository<DataDictionaryItem> itemRepository,
        ICurrentTenant currentTenant)
    {
        this.dictionaryRepository = dictionaryRepository;
        this.itemRepository = itemRepository;
        this.currentTenant = currentTenant;
    }

    public virtual async Task SeedAsync(DataSeedContext context)
    {
        using (currentTenant.Change(context?.TenantId))
        {
            await SeedPositionLevelAsync();
            await SeedUserSexAsync();
            await SeedOrganizationUnitCategoryAsync();
            await SeedOrganizationUnitTypeAsync();
        }
    }

    private async Task SeedPositionLevelAsync()
    {
        var exists = await dictionaryRepository.Select.Where(x => x.Name == "position-level").AnyAsync();
        if (exists)
        {
            return;
        }

        var dictionary = await dictionaryRepository.InsertAsync(new DataDictionary
        {
            Name = "position-level",
            DisplayName = "职位职级",
            IsStatic = true,
            IsEnabled = true
        });

        var items = new List<DataDictionaryItem>();
        for (int i = 1; i <= 10; i++)
        {
            items.Add(new DataDictionaryItem
            {
                DictionaryName = dictionary.Name,
                Value = i.ToString("D2"),
                Label = $"L{i:D2}",
                IsEnabled = true,                  
            });
        }
        await itemRepository.InsertAsync(items);
    }

    private async Task SeedUserSexAsync()
    {
        var exists = await dictionaryRepository.Select.Where(x => x.Name == "user-sex").AnyAsync();
        if (exists)
        {
            return;
        }

        var dictionary = await dictionaryRepository.InsertAsync(new DataDictionary
        {
            Name = "user-sex",
            DisplayName = "用户性别",
            IsEnabled = true,
            IsStatic = true
        });

        var items = new List<DataDictionaryItem>([
            new (){
                DictionaryName = dictionary.Name,
                Value = "0",
                Label = "未知",
                IsEnabled = true
            },
            new() {
                DictionaryName = dictionary.Name,
                Value = "1",
                Label = "男",
                IsEnabled = true
            },
            new (){
                DictionaryName = dictionary.Name,
                Value = "2",
                Label = "女",
                IsEnabled = true
            }
        ]);
        await itemRepository.InsertAsync(items);
    }

    private async Task SeedOrganizationUnitCategoryAsync()
    {
        var exists = await dictionaryRepository.Select.Where(x => x.Name == "organization-unit-category").AnyAsync();
        if (exists)
        {
            return;
        }

        var dictionary = await dictionaryRepository.InsertAsync(new DataDictionary
        {
            Name = "organization-unit-category",
            DisplayName = "机构种类",
            Remark = "机构的大类别，如：公司机构、客户机构等",
            IsEnabled = true,
            IsStatic = true
        });

        var items = new List<DataDictionaryItem>([
            new (){
                DictionaryName = dictionary.Name,
                Value = "0",
                Label = "默认",
                IsEnabled = true,
                IsStatic = true 
            }
        ]);
        await itemRepository.InsertAsync(items);
    }

    private async Task SeedOrganizationUnitTypeAsync()
    {
        var exists = await dictionaryRepository.Select.Where(x => x.Name == "organization-unit-type").AnyAsync();
        if (exists)
        {
            return;
        }

        var dictionary = await dictionaryRepository.InsertAsync(new DataDictionary
        {
            Name = "organization-unit-type",
            DisplayName = "机构类型",
            Remark = "机构的细类别，如：集团公司、子公司、分公司等",
            IsEnabled = true,
            IsStatic = true
        });
    }
}
