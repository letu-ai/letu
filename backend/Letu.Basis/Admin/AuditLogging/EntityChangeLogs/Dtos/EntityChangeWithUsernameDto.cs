namespace Letu.Basis.Admin.AuditLogging.EntityChangeLogs.Dtos;

public class EntityChangeWithUsernameDto
{
    public EntityChangeDto EntityChange { get; set; }

    public string UserName { get; set; }
}
