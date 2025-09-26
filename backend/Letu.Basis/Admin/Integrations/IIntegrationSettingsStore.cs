namespace Letu.Basis.Admin.Integrations;

public interface IIntegrationSettingsStore
{
    Task<bool> IsEnabledAsync(string name);

    Task SetEnabledAsync(string name, bool enabled);

    Task<T?> GetValuesAsync<T>(string name) where T : class;

    Task SetValuesAsync<T>(string name, T values) where T : class;

    Task<List<IntegrationEnableStatusOutput>> GetListAsync();

}