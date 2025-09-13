using Letu.Basis.Admin.Roles;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity;
using Letu.Core.Utils;
using Letu.Repository;
using Letu.Shared.Consts;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Volo.Abp;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Guids;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Uow;

namespace Letu.Basis.DataSeed;

public class IdentityDataSeedContributor : IDataSeedContributor, ITransientDependency
{
    public const string AdminEmailPropertyName = "AdminEmail";
    public const string AdminEmailDefaultValue = "admin@abp.io";
    public const string AdminUserNamePropertyName = "AdminUserName";
    public const string AdminUserNameDefaultValue = "admin";
    public const string AdminPasswordPropertyName = "AdminPassword";
    public const string AdminPasswordDefaultValue = "1q2w3E*";

    private readonly IGuidGenerator guidGenerator;
    private readonly IFreeSqlRepository<Role> roleRepository;
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IFreeSqlRepository<UserInRole> userRoleRepository;
    private readonly ICurrentTenant currentTenant;
    private readonly IOptions<IdentityOptions> identityOptions;

    public IdentityDataSeedContributor(
        IGuidGenerator guidGenerator,
        IFreeSqlRepository<Role> roleRepository,
        IFreeSqlRepository<User> userRepository,
        IFreeSqlRepository<UserInRole> userRoleRepository,
        ICurrentTenant currentTenant,
        IOptions<IdentityOptions> identityOptions)
    {
        this.guidGenerator = guidGenerator;
        this.roleRepository = roleRepository;
        this.userRepository = userRepository;
        this.userRoleRepository = userRoleRepository;
        this.currentTenant = currentTenant;
        this.identityOptions = identityOptions;
    }

    [UnitOfWork]
    public virtual async Task SeedAsync(DataSeedContext context)
    {
        await SeedAdminUserAsync(
            context?[AdminEmailPropertyName] as string ?? AdminEmailDefaultValue,
            context?[AdminPasswordPropertyName] as string ?? AdminPasswordDefaultValue,
            context?.TenantId,
            context?[AdminUserNamePropertyName] as string ?? AdminUserNameDefaultValue
        );
    }

    private async Task<IdentityDataSeedResult> SeedAdminUserAsync(
        string adminEmail,
        string adminPassword,
        Guid? tenantId = null,
        string? adminUserName = null)
    {
        Check.NotNullOrWhiteSpace(adminEmail, nameof(adminEmail));
        Check.NotNullOrWhiteSpace(adminPassword, nameof(adminPassword));

        using (currentTenant.Change(tenantId))
        {
            var result = new IdentityDataSeedResult();

            // 设置默认管理员用户名
            if (adminUserName.IsNullOrWhiteSpace())
            {
                adminUserName = AdminUserNameDefaultValue;
            }

            // 检查管理员用户是否已存在
            var adminUser = await userRepository.Select.Where(x => x.UserName == adminUserName).ToOneAsync();
            if (adminUser != null)
            {
                return result;
            }

            // 创建管理员角色
            const string adminRoleName = "admin";
            var adminRole = await roleRepository.Select.Where(x => x.Name == adminRoleName).ToOneAsync();
            if (adminRole == null)
            {
                adminRole = new Role
                {
                    Name = adminRoleName,
                    Remark = "系统管理员角色",
                    IsEnabled = true,
                    TenantId = tenantId,
                };

                await roleRepository.InsertAsync(adminRole);
                result.CreatedAdminRole = true;
            }

            // 生成密码盐和加密密码
            var passwordSalt = EncryptionUtils.GetPasswordSalt();
            var hashedPassword = EncryptionUtils.CalcPasswordHash(adminPassword, passwordSalt);

            // 创建管理员用户
            adminUser = new User(guidGenerator.Create(), adminUserName)
            {
                PasswordHash = hashedPassword,
                PasswordSalt = passwordSalt,
                NickName = adminUserName,
                Avatar = AdminConsts.AvatarMale,
                IsEnabled = true,
                TenantId = tenantId,
            };

            await userRepository.InsertAsync(adminUser);
            result.CreatedAdminUser = true;

            // 创建用户角色关联
            var userRole = new UserInRole
            {
                UserId = adminUser.Id,
                RoleId = adminRole.Id,
                TenantId = tenantId,
            };

            await userRoleRepository.InsertAsync(userRole);

            return result;
        }
    }
}
