using Letu.Basis.Admin.DataDictionaries;
using Letu.Repository;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.PermissionManagement;

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
        await SeedPositionLevelAsync();
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
                IsEnabled = true
            });
        }
        await itemRepository.InsertAsync(items);
    }
}
