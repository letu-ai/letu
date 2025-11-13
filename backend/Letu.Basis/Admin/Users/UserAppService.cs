using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.OrganizationUnits;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Roles.Dtos;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.Admin.UserTags;
using Letu.Basis.Admin.UserTags.Dtos;
using Letu.Basis.Oss;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Utils;
using Letu.Logging.BusinessLogs;
using Letu.Repository;
using Letu.Shared.Consts;
using Letu.Shared.Generated;
using Volo.Abp.BlobStoring;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;

namespace Letu.Basis.Admin.Users;

public class UserAppService : BasisAppService, IUserAppService
{
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IFreeSqlRepository<UserInRole> userRoleRepository;
    private readonly IFreeSqlRepository<UserInTag> userTagRepository;
    private readonly IFreeSqlRepository<OrganizationUnit> orgRepostory;
    private readonly IBusinessLogManager businessLogManager;
    private readonly IDistributedEventBus eventBus;
    private readonly IBlobContainer<AvatarBlobContainer> avatarBlobContainer;
    public UserAppService(IFreeSqlRepository<User> userRepository,
        IFreeSqlRepository<UserInRole> userRoleRepository,
        IFreeSqlRepository<UserInTag> userTagRepository,
        IFreeSqlRepository<OrganizationUnit> orgRepostory,
        IBusinessLogManager businessLogManager,
        IDistributedEventBus eventBus,
        IBlobContainer<AvatarBlobContainer> avatarBlobContainer)
    {
        this.userRepository = userRepository;
        this.userRoleRepository = userRoleRepository;
        this.userTagRepository = userTagRepository;
        this.orgRepostory = orgRepostory;
        this.businessLogManager = businessLogManager;
        this.eventBus = eventBus;
        this.avatarBlobContainer = avatarBlobContainer;
    }

    [BusinessLog("用户管理", BusinessOperateType.Create, "创建用户{{UserName}}({{Email}})")]
    public async Task<Guid> AddUserAsync(UserCreateInput input)
    {
        await CheckUserExists(input.UserName, input.Phone, input.Email);

        //TODO: 通过设置的密码强度策略来校验
        if (!RegexCodeGen.Password().IsMatch(input.Password))
        {
            throw HttpFriendlyException.BadRequest("密码格式不正确");
        }

        var salt = EncryptionUtils.GetPasswordSalt();
        var user = new User(GuidGenerator.Create(), input.UserName)
        {
            PasswordSalt = salt,
            PasswordHash = EncryptionUtils.CalcPasswordHash(input.Password, salt),
            NickName = input.NickName,
            IsEnabled = true
        };

        ObjectMapper.Map(input, user);

        if (string.IsNullOrWhiteSpace(input.Avatar))
        {
            user.Avatar = AdminConsts.AvatarMale;
        }
        user = await userRepository.InsertAsync(user);

        // 保存用户标签关联
        if (input.TagIds != null && input.TagIds.Count > 0)
        {
            await SaveUserTagsAsync(user.Id, input.TagIds);
        }

        businessLogManager.Current?.AddVariable("UserName", input.UserName);
        businessLogManager.Current?.AddVariable("Email", input.Email ?? "无邮箱");
        businessLogManager.Current?.AddVariable("EntityId", user.Id);

        return user.Id;
    }

    [BusinessLog("用户管理", BusinessOperateType.Update, "修改用户{{UserName}}({{Email}})的资料")]
    public async Task<Guid> UpdateUserAsync(Guid id, UserUpdateInput input)
    {
        await CheckUserExists(null, input.Phone, input.Email, id);

        var user = await userRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound($"用户ID:{id}不存在。");

        businessLogManager.Current?.AddVariable("UserName", user.UserName);
        businessLogManager.Current?.AddVariable("Email", user.Email ?? "无邮箱");
        businessLogManager.Current?.AddVariable("EntityId", id);

        ObjectMapper.Map(input, user);
        await userRepository.UpdateAsync(user);

        // 更新用户标签关联
        if (input.TagIds != null)
        {
            await SaveUserTagsAsync(user.Id, input.TagIds);
        }

        // 发布用户更新事件
        var userUpdatedEto = new EntityUpdatedEto<UserEto>(new UserEto()
        {
            Id = id,
            UserName = user.UserName,
            TenantId = user.TenantId,
            Name = user.NickName,
            IsActive = user.IsEnabled
        });

        await eventBus.PublishAsync(userUpdatedEto);

        return user.Id;
    }

    private async Task CheckUserExists(string? userName, string? phone, string? email, Guid? excludeId = null)
    {
        System.Linq.Expressions.Expression<Func<User, bool>> condition = u => false; // 初始化为一个假条件

        if (!string.IsNullOrEmpty(userName))
        {
            var lowerName = userName.ToLower(); // 预先转换为小写
            condition = condition.Or(u => u.UserName.ToLower() == lowerName);
        }

        if (!string.IsNullOrWhiteSpace(phone))
        {
            var lowerPhone = phone.ToLower();
            condition = condition.Or(u => u.Phone.ToLower() == lowerPhone);
        }

        if (!string.IsNullOrWhiteSpace(email))
        {
            var lowerEmail = email.ToLower();
            condition = condition.Or(u => u.Email.ToLower() == lowerEmail);
        }

        var existUser = await userRepository.Select
            .Where(condition)
            .WhereIf(excludeId.HasValue, u => u.Id != excludeId!.Value)
            .FirstAsync();

        if (existUser != null)
        {
            if (userName == existUser.UserName)
                throw HttpFriendlyException.BadRequest($"账号{userName}已存在");

            if (!string.IsNullOrWhiteSpace(email) && email == existUser.Email)
                throw HttpFriendlyException.BadRequest($"邮箱{email}已存在");

            if (!string.IsNullOrWhiteSpace(phone) && phone == existUser.Phone)
                throw HttpFriendlyException.BadRequest($"手机号{phone}已存在");
        }
    }

    [BusinessLog("用户管理", BusinessOperateType.Update, "分配用户{{UserId}}到角色{{RoleId}}")]
    public async Task<bool> AssignRoleAsync(Guid userId, AssignRoleDto input)
    {
        businessLogManager.Current?.AddVariable("UserId", userId);
        businessLogManager.Current?.AddVariable("RoleId", string.Join(',', input.RoleIds ?? []));
        businessLogManager.Current?.AddVariable("EntityId", userId);

        await userRoleRepository.DeleteAsync(x => x.UserId == userId);
        if (input.RoleIds != null)
        {
            var items = new List<UserInRole>();
            foreach (var item in input.RoleIds)
            {
                items.Add(new UserInRole
                {
                    UserId = userId,
                    RoleId = item
                });
            }
            if (items.Count > 0)
            {
                await userRoleRepository.InsertAsync(items);
            }
        }
        return true;
    }

    [BusinessLog("用户管理", BusinessOperateType.Delete, "删除用户{{UserName}}的用户")]
    public async Task<bool> DeleteUserAsync(Guid id)
    {
        if (CurrentUser.Id == id)
        {
            throw HttpFriendlyException.BadRequest("不能删除自己");
        }
        var user = await userRepository.Where(x => x.Id == id).FirstAsync();
        await userRepository.DeleteAsync(x => x.Id == id);
        businessLogManager.Current?.AddVariable("UserName", user.UserName);
        businessLogManager.Current?.AddVariable("EntityId", id);

        var userDeleteEto = new EntityDeletedEto<UserEto>(new UserEto()
        {
            Id = id,
            UserName = user.UserName,
            TenantId = user.TenantId,
            Name = user.NickName,
            IsActive = user.IsEnabled
        });

        await eventBus.PublishAsync(userDeleteEto);

        return true;
    }

    public async Task<PagedResult<UserListOutput>> GetUserListAsync(UserListInput input)
    {
        // 如果指定了组织机构ID，获取该机构及其所有子孙机构的ID列表
        List<Guid>? organizationUnitIds = null;
        if (input.OrganizationUnitId.HasValue)
        {
            organizationUnitIds = await GetOrganizationUnitIdsWithChildren(input.OrganizationUnitId.Value);
        }

        var query = userRepository.Select
            .From<Department, PositionGroup, Employee, OrganizationUnit>((u, d, p, e, o) => u
                .LeftJoin(u1 => u1.DepartmentId == d.Id)
                .LeftJoin(u1 => u1.PositionId == p.Id)
                .LeftJoin(u1 => u1.EmployeeId == e.Id)
                .LeftJoin(u1 => u1.OrganizationUnitId == o.Id))
            .WhereIf(!string.IsNullOrEmpty(input.Keyword), (u, d, p, e, o) => u.UserName.Contains(input.Keyword!) || u.NickName.Contains(input.Keyword!) || u.Phone.Contains(input.Keyword!) || u.Email.Contains(input.Keyword!))
            .WhereIf(organizationUnitIds != null && organizationUnitIds.Count > 0, (u, d, p, e, o) => organizationUnitIds!.Contains(u.OrganizationUnitId!.Value));

        // 标签筛选（OR逻辑）
        if (input.TagIds != null && input.TagIds.Count > 0)
        {
            var userIdsWithTags = await userTagRepository.Select
                .Where(ut => input.TagIds.Contains(ut.TagId))
                .ToListAsync(ut => ut.UserId);

            if (userIdsWithTags.Count > 0)
            {
                query = query.Where((u, d, p, e, o) => userIdsWithTags.Contains(u.Id));
            }
            else
            {
                // 如果没有用户匹配标签，返回空结果
                return new PagedResult<UserListOutput>(0, new List<UserListOutput>());
            }
        }

        var rows = await query
            .OrderByDescending((u, d, p, e, o) => u.CreationTime)
            .Count(out var total)
            .Page(input.Current, input.PageSize)
            .ToListAsync((u, d, p, e, o) => new UserListOutput
            {
                Id = u.Id,
                UserName = u.UserName,
                Avatar = u.Avatar,
                NickName = u.NickName,
                IsEnabled = u.IsEnabled,
                Phone = u.Phone,
                Email = u.Email,
                DepartmentId = u.DepartmentId,
                DepartmentName = d.Name,
                PositionId = u.PositionId,
                PositionName = p.GroupName,
                EmployeeId = u.EmployeeId,
                EmployeeName = e.Name,
                OrganizationUnitId = u.OrganizationUnitId,
                OrganizationUnitName = o.Name
            });

        // 为每个用户加载标签信息
        if (rows.Count > 0)
        {
            var userIds = rows.Select(r => r.Id).ToList();
            var userTags = await userTagRepository.Select
                .From<UserTag>((ut, t) => ut.InnerJoin(ut1 => ut1.TagId == t.Id))
                .Where((ut, t) => userIds.Contains(ut.UserId))
                .ToListAsync((ut, t) => new { ut.UserId, TagId = t.Id, TagName = t.Name, TagColor = t.Color });

            foreach (var row in rows)
            {
                row.Tags = userTags
                    .Where(ut => ut.UserId == row.Id)
                    .Select(ut => new UserTagInfo
                    {
                        Id = ut.TagId,
                        Name = ut.TagName,
                        Color = ut.TagColor
                    })
                    .ToList();
            }
        }

        return new PagedResult<UserListOutput>(total, rows);
    }

    /// <summary>
    /// 获取指定组织机构及其所有子孙机构的ID列表
    /// </summary>
    private async Task<List<Guid>> GetOrganizationUnitIdsWithChildren(Guid parentId)
    {
        // 获取父级组织的Code
        var parentCode = await orgRepostory.Select
            .Where(x => x.Id == parentId)
            .FirstAsync(x => x.Code);

        if (string.IsNullOrEmpty(parentCode))
        {
            // 如果找不到父级组织，返回空列表
            return new List<Guid>();
        }

        // 通过Code的前缀匹配，一次查询获取所有子孙节点（包括自己）
        var allIds = await orgRepostory.Select
            .Where(x => x.Code.StartsWith(parentCode))
            .ToListAsync(x => x.Id);

        return allIds;
    }

    public async Task<(Stream?, string)> GetAvatarAsync(string? avatar, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrEmpty(avatar))
        {
            return (null, "");
        }

        if (await avatarBlobContainer.ExistsAsync(avatar))
        {
            var stream = await avatarBlobContainer.GetAsync(avatar, cancellationToken);
            return (stream, MimeMapper.GetContentType(avatar));
        }
        else
        {
            return (null, "");
        }
    }

    public async Task<Guid[]> GetUserRoleIdsAsync(Guid uid)
    {
        return [.. await userRoleRepository.Where(x => x.UserId == uid).ToListAsync(x => x.RoleId)];
    }

    [BusinessLog("用户管理", BusinessOperateType.Update, "切换用户{{UserName}}的启用状态为{{IsEnabled}}")]
    public async Task<bool> SwitchUserEnabledStatusAsync(Guid id)
    {
        var entity = await userRepository.Where(x => x.Id == id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound("数据不存在");
        entity.IsEnabled = !entity.IsEnabled;
        await userRepository.UpdateAsync(entity);
        businessLogManager.Current?.AddVariable("UserName", entity.UserName);
        businessLogManager.Current?.AddVariable("IsEnabled", entity.IsEnabled);
        businessLogManager.Current?.AddVariable("EntityId", id);

        // TODO: 启用用户时发出Event通知？

        return true;
    }

    [BusinessLog("用户管理", BusinessOperateType.Update, "重置用户{{UserName}}的密码。")]
    public async Task ResetUserPasswordAsync(ResetUserPwdDto dto)
    {
        var user = await userRepository.Where(x => x.Id == dto.UserId).FirstAsync();
        if (!RegexCodeGen.Password().IsMatch(dto.Password))
        {
            throw HttpFriendlyException.BadRequest("密码格式不正确");
        }
        businessLogManager.Current?.AddVariable("UserName", user.UserName);
        businessLogManager.Current?.AddVariable("EntityId", user.Id);

        user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
        user.PasswordHash = EncryptionUtils.CalcPasswordHash(dto.Password!, user.PasswordSalt);
        await userRepository.UpdateAsync(user);
    }

    public async Task<List<SelectOption>> GetUserSelectOptionsByIdsAsync(List<Guid> userIds)
    {
        if (userIds == null || userIds.Count == 0)
        {
            return [];
        }

        return await userRepository.Select
            .Where(x => userIds.Contains(x.Id))
            .OrderBy(x => x.UserName)
            .ToListAsync(x => new SelectOption
            {
                Label = $"{x.UserName} {x.NickName}",
                Value = x.Id.ToString()
            });
    }

    public Task<List<SelectOption>> GetUserSelectOptionsAsync(string? keyword)
    {
        return userRepository.Where(x => x.IsEnabled)
            .WhereIf(!string.IsNullOrEmpty(keyword), x => x.UserName.Contains(keyword!) || x.NickName.Contains(keyword!))
            .Limit(50)
            .OrderBy(x => x.UserName)
            .ToListAsync(x => new SelectOption { Value = x.Id.ToString(), Label = $"{x.UserName} {x.NickName}" });
    }

    public async Task<UserExtraInfo> GetUserExtraInfoAsync()
    {
        if (CurrentUser.IsAuthenticated == false)
        {
            return new UserExtraInfo();
        }

        return await userRepository.Select
            .From<OrganizationUnit, Department, PositionGroup>((u, o, d, p) => u
                .LeftJoin(u1 => u1.OrganizationUnitId == o.Id)
                .LeftJoin(u1 => u1.DepartmentId == d.Id)
                .LeftJoin(u1 => u1.PositionId == p.Id))
            .Where((u, o, d, p) => u.Id == CurrentUser.Id)
            .FirstAsync((u, o, d, p) => new UserExtraInfo
            {
                OrganizationUnitId = u.OrganizationUnitId,
                OrganizationUnitName = o.Name,
                DepartmentId = u.DepartmentId,
                DepartmentName = d.Name,
                PositionId = u.PositionId,
                PositionName = p.GroupName
            });
    }

    [BusinessLog("用户管理", BusinessOperateType.Update, "分配用户{{UserId}}的标签")]
    public async Task<bool> AssignTagsAsync(Guid userId, List<Guid> tagIds)
    {
        businessLogManager.Current?.AddVariable("UserId", userId);
        businessLogManager.Current?.AddVariable("EntityId", userId);

        await SaveUserTagsAsync(userId, tagIds);
        return true;
    }

    /// <summary>
    /// 保存用户标签关联
    /// </summary>
    private async Task SaveUserTagsAsync(Guid userId, List<Guid> tagIds)
    {
        // 删除现有关联
        await userTagRepository.DeleteAsync(x => x.UserId == userId);

        // 添加新关联
        if (tagIds != null && tagIds.Count > 0)
        {
            var userTags = tagIds.Select(tagId => new UserInTag
            {
                UserId = userId,
                TagId = tagId
            }).ToList();

            await userTagRepository.InsertAsync(userTags);
        }
    }
}