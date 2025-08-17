using JetBrains.Annotations;
using Letu.Basis.Admin.PermissionManagement.Dtos;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.PermissionManagement;

public interface IPermissionAppService : IApplicationService
{
    Task<GetPermissionListResultDto> GetAsync([NotNull] string providerName, [NotNull] string providerKey);


    Task UpdateAsync([NotNull] string providerName, [NotNull] string providerKey, UpdatePermissionsDto input);
}
