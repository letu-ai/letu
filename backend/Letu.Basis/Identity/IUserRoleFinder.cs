namespace Letu.Basis.Identity;

public interface IUserRoleFinder
{
    Task<string[]> GetRoleNamesAsync(Guid userId);
}
