using Volo.Abp.Settings;

namespace Letu.Basis.Admin.SettingManagement;
public interface ISettingManagementAppService
{
    Task<List<SettingValue>> GetAllAsync(string[] names);
    Task UpdateAsync(List<SettingValue> values);
}