using FreeSql;
using Letu.Basis.Admin.AuditLogging.EntityChangeLogs.Dtos;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Application.Services;
using Volo.Abp.Auditing;
using Volo.Abp.AuditLogging;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.AuditLogging.EntityChangeLogs;

[DisableAuditing]
public class EntityChangeLogAppService : ApplicationService, IEntityChangeLogAppService
{
    private readonly IFreeSql _freeSql;
    private readonly IPermissionChecker _permissionChecker;
    private readonly IPermissionDefinitionManager _permissionDefinitionManager;

    public EntityChangeLogAppService(
        IFreeSql freeSql,
        IPermissionChecker permissionChecker,
        IPermissionDefinitionManager permissionDefinitionManager)
    {
        _freeSql = freeSql;
        _permissionChecker = permissionChecker;
        _permissionDefinitionManager = permissionDefinitionManager;
    }

    public virtual async Task<PagedResultDto<EntityChangeDto>> GetEntityChangesAsync(GetEntityChangesInput input)
    {
        var query = _freeSql.Select<EntityChange>()
            .WhereIf(input.AuditLogId.HasValue, x => x.AuditLogId == input.AuditLogId)
            .WhereIf(input.StartDate.HasValue, x => x.ChangeTime >= input.StartDate!.Value)
            .WhereIf(input.EndDate.HasValue, x => x.ChangeTime <= input.EndDate!.Value)
            .WhereIf(input.ChangeType.HasValue, x => x.ChangeType == input.ChangeType)
            .WhereIf(!string.IsNullOrEmpty(input.EntityId), x => x.EntityId == input.EntityId)
            .WhereIf(!string.IsNullOrEmpty(input.EntityTypeFullName), x => x.EntityTypeFullName == input.EntityTypeFullName);

        var totalCount = await query.CountAsync();
        if (totalCount == 0)
        {
            return new PagedResultDto<EntityChangeDto>();
        }

        // Handle sorting
        if (!string.IsNullOrEmpty(input.Sorting))
        {
            query = query.OrderByPropertyNameIf(!string.IsNullOrEmpty(input.Sorting), input.Sorting, false);
        }
        else
        {
            query = query.OrderByDescending(x => x.ChangeTime);
        }

        // Pagination and include property changes
        var list = await query
            .Skip(input.SkipCount)
            .Take(input.MaxResultCount)
            .Include(x => x.PropertyChanges)
            .ToListAsync();

        return new PagedResultDto<EntityChangeDto>(totalCount, ObjectMapper.Map<List<EntityChange>, List<EntityChangeDto>>(list));
    }

    [AllowAnonymous]
    public virtual async Task<List<EntityChangeWithUsernameDto>> GetEntityChangesWithUsernameAsync(EntityChangeFilter input)
    {
        await CheckPermissionForEntity(input.EntityTypeFullName);

        // Query entity changes with username by joining AuditLog
        var entityChanges = await _freeSql.Select<EntityChange>()
            .Where(ec => ec.EntityId == input.EntityId && ec.EntityTypeFullName == input.EntityTypeFullName)
            .Include(ec => ec.PropertyChanges)
            .ToListAsync();

        var auditLogIds = entityChanges.Select(ec => ec.AuditLogId).Distinct().ToList();
        var auditLogs = await _freeSql.Select<AuditLog>()
            .Where(al => auditLogIds.Contains(al.Id))
            .ToListAsync();

        // Create result objects
        var entityChangesWithUsername = new List<EntityChangeWithUsername>();
        foreach (var entityChange in entityChanges)
        {
            var auditLog = auditLogs.FirstOrDefault(al => al.Id == entityChange.AuditLogId);
            if (auditLog != null)
            {
                entityChangesWithUsername.Add(new EntityChangeWithUsername
                {
                    EntityChange = entityChange,
                    UserName = auditLog.UserName
                });
            }
        }

        return ObjectMapper.Map<List<EntityChangeWithUsername>, List<EntityChangeWithUsernameDto>>(entityChangesWithUsername);
    }

    public virtual async Task<EntityChangeWithUsernameDto> GetEntityChangeWithUsernameAsync(Guid entityChangeId)
    {
        // Query entity change
        var entityChange = await _freeSql.Select<EntityChange>()
            .Where(ec => ec.Id == entityChangeId)
            .Include(ec => ec.PropertyChanges)
            .ToOneAsync();

        if (entityChange == null)
        {
            throw new EntityNotFoundException(typeof(EntityChange), entityChangeId);
        }

        // Get related audit log for username
        var auditLog = await _freeSql.Select<AuditLog>()
            .Where(al => al.Id == entityChange.AuditLogId)
            .ToOneAsync();

        if (auditLog == null)
        {
            throw new EntityNotFoundException(typeof(AuditLog), entityChange.AuditLogId);
        }

        var entityChangeWithUsername = new EntityChangeWithUsername
        {
            EntityChange = entityChange,
            UserName = auditLog.UserName
        };

        return ObjectMapper.Map<EntityChangeWithUsername, EntityChangeWithUsernameDto>(entityChangeWithUsername);
    }

    public virtual async Task<EntityChangeDto> GetEntityChangeAsync(Guid entityChangeId)
    {
        var entityChange = await _freeSql.Select<EntityChange>()
            .Where(x => x.Id == entityChangeId)
            .Include(x => x.PropertyChanges)
            .ToOneAsync();

        if (entityChange == null)
        {
            throw new EntityNotFoundException(typeof(EntityChange), entityChangeId);
        }

        return ObjectMapper.Map<EntityChange, EntityChangeDto>(entityChange);
    }

    protected virtual async Task CheckPermissionForEntity(string entityFullName)
    {
        string entityPermission = "AuditLogging.ViewChangeHistory:" + entityFullName;

        if (await _permissionDefinitionManager.GetOrNullAsync(entityPermission) == null)
        {
            await AuthorizationService.CheckAsync("AuditLogging.View");
        }
        else
        {
            var granted = await _permissionChecker.IsGrantedAsync(entityPermission);
            if (!granted)
            {
                await AuthorizationService.CheckAsync("AuditLogging.View");
            }
        }
    }
}