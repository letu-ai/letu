using AutoMapper;
using Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;
using Letu.Basis.Admin.AuditLogging.EntityChangeLogs.Dtos;
using Volo.Abp.AuditLogging;

namespace Letu.Basis.Admin.AuditLogging;

public class LetuAuditLoggingAdminAutoMapperProfile : Profile
{
    public LetuAuditLoggingAdminAutoMapperProfile()
    {
        // AuditLog mappings
        CreateMap<AuditLog, AuditLogListOutput>();
        CreateMap<AuditLog, AuditLogDetailOutput>();
        CreateMap<AuditLogAction, AuditLogActionDto>();


        // EntityChange mappings
        CreateMap<EntityChange, EntityChangeDto>();
        CreateMap<EntityPropertyChange, EntityPropertyChangeDto>();
        CreateMap<EntityChangeWithUsername, EntityChangeWithUsernameDto>();
    }
}