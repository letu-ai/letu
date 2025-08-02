using Letu.Basis.Admin.AuditLogging.EntityChangeLogs.Dtos;
using Volo.Abp.Application.Dtos;

namespace Letu.Basis.Admin.AuditLogging.EntityChangeLogs;

public interface IEntityChangeLogAppService
{
    Task<PagedResultDto<EntityChangeDto>> GetEntityChangesAsync(GetEntityChangesInput input);

    Task<List<EntityChangeWithUsernameDto>> GetEntityChangesWithUsernameAsync(EntityChangeFilter input);

    Task<EntityChangeWithUsernameDto> GetEntityChangeWithUsernameAsync(Guid entityChangeId);

    Task<EntityChangeDto> GetEntityChangeAsync(Guid entityChangeId);
}
