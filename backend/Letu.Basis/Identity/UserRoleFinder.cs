using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Roles;
using Letu.Repository;
using Volo.Abp.DependencyInjection;

namespace Letu.Basis.Identity;

public class UserRoleFinder : IUserRoleFinder, ITransientDependency
{
    protected IFreeSqlRepository<User> userRepository { get; }

    public UserRoleFinder(IFreeSqlRepository<User> userRepository)
    {
        this.userRepository = userRepository;
    }


    public async Task<string[]> GetRoleNamesAsync(Guid userId)
    {
        var roleNames = await userRepository.Orm.Select<UserInRole, Role>()
            .LeftJoin((ur, r) => ur.RoleId == r.Id)
            .Where((ur, r) => ur.UserId == userId)
            .ToListAsync((ur, r) => r.Name);

        return roleNames.Where(x => !string.IsNullOrEmpty(x)).ToArray();
    }
}
