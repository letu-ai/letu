using Letu.Core.Security.Serialization;
using Letu.Repository;
using System.Text.Json;
using System.Text.Json.Serialization.Metadata;
using Volo.Abp;
using Volo.Abp.Caching;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Security.Encryption;

namespace Letu.Basis.Admin.Integrations;

public class IntegrationSettingsStore : IIntegrationSettingsStore, ITransientDependency
{
    private readonly IFreeSqlRepository<IntegrationSettings> integrationSettingsRepository;
    private readonly ICurrentTenant currentTenant;
    private readonly IDistributedCache<IntegrationSettingsCacheItem> cache;

    private readonly JsonSerializerOptions jsonSerializerOptions;

    public IntegrationSettingsStore(
        IFreeSqlRepository<IntegrationSettings> integrationSettingsRepository,
        ICurrentTenant currentTenant,
        IDistributedCache<IntegrationSettingsCacheItem> cache,
        IStringEncryptionService stringEncryptionService)
    {
        var encryptedPropertyModifier = new EncryptedPropertyModifier(stringEncryptionService);
        this.integrationSettingsRepository = integrationSettingsRepository;
        this.currentTenant = currentTenant;
        this.cache = cache;
        jsonSerializerOptions = new JsonSerializerOptions();
        jsonSerializerOptions.TypeInfoResolver = new DefaultJsonTypeInfoResolver
        {
            Modifiers = { encryptedPropertyModifier.ModifyTypeInfo }
        };
    }

    public virtual async Task<List<IntegrationEnableStatusOutput>> GetListAsync()
    {
        return await integrationSettingsRepository.Select.ToListAsync<IntegrationEnableStatusOutput>();
    }

    public virtual async Task<bool> IsEnabledAsync(string name)
    {
        var settings = await GetAsync(name);
        return settings?.IsEnabled ?? false;
    }

    public virtual async Task SetEnabledAsync(string name, bool enabled)
    {
        Check.NotNullOrWhiteSpace(name, nameof(name));

        var settings = await integrationSettingsRepository.OneAsync(x => x.Name == name);
        if (settings == null)
        {
            settings = new IntegrationSettings
            {
                Name = name,
                IsEnabled = enabled,
            };
            await integrationSettingsRepository.InsertAsync(settings);
        }
        else
        {
            settings.IsEnabled = enabled;
            await integrationSettingsRepository.UpdateAsync(settings);
        }

        await cache.RemoveAsync(CalculateCacheKey(name));
    }

    public virtual async Task<T?> GetValuesAsync<T>(string name) where T : class
    {
        var settings = await GetAsync(name);
        if (settings?.Values == null)
        {
            return null;
        }

        try
        {
            return JsonSerializer.Deserialize<T>(settings.Values, jsonSerializerOptions);
        }
        catch (JsonException ex)
        {
            throw new UserFriendlyException($"Failed to deserialize values for '{name}'.", innerException: ex);
        }
    }

    public virtual async Task SetValuesAsync<T>(string name, T values) where T : class
    {
        Check.NotNullOrWhiteSpace(name, nameof(name));
        Check.NotNull(values, nameof(values));

        var setting = await integrationSettingsRepository.OneAsync(x => x.Name == name);

        try
        {
            var jsonValues = JsonSerializer.Serialize(values, jsonSerializerOptions);

            if (setting == null)
            {
                setting = new IntegrationSettings
                {
                    Name = name,
                    IsEnabled = false,
                    Values = jsonValues,
                };
                await integrationSettingsRepository.InsertAsync(setting);
            }
            else
            {
                setting.Values = jsonValues;
                await integrationSettingsRepository.UpdateAsync(setting);
            }

            await cache.RemoveAsync(CalculateCacheKey(name));
        }
        catch (JsonException ex)
        {
            throw new UserFriendlyException($"Failed to serialize values for '{name}'.", innerException: ex);
        }
    }

    private async Task<IntegrationSettings?> GetAsync(string name)
    {
        Check.NotNullOrWhiteSpace(name, nameof(name));

        var cacheKey = CalculateCacheKey(name);
        var cacheItem = await cache.GetAsync(cacheKey);

        if (cacheItem?.Settings != null)
        {
            return cacheItem.Settings;
        }

        var settings = await integrationSettingsRepository.OneAsync(x => x.Name == name);

        if (settings != null)
        {
            await cache.SetAsync(
                cacheKey,
                new IntegrationSettingsCacheItem { Settings = settings });
        }

        return settings;
    }

    private string CalculateCacheKey(string name)
    {
        return $"integration-settings:{currentTenant.Id ?? Guid.Empty}:{name}";
    }
}

public class IntegrationSettingsCacheItem
{
    public IntegrationSettings? Settings { get; set; }
}