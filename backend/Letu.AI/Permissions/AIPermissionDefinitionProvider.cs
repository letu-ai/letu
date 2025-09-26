using Letu.Basis.Localization;
using Letu.Basis.Permissions;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Localization;

namespace Letu.AI.Permissions;

public class AIPermissionDefinitionProvider : PermissionDefinitionProvider
{
    public override void Define(IPermissionDefinitionContext context)
    {
        // AI应用权限
        var aiGroup = context.AddGroup(AIPermissions.AIGroupName, L("Permission:Admin.BaseData"));

        // 系统设置
        var settingGroup = context.GetGroupOrNull(BasisPermissions.SettingGroupName);
        if (settingGroup != null)
        {
            DefineIntegrationManagement(settingGroup);
        }
    }

    // 第三方集成管理
    public void DefineIntegrationManagement(PermissionGroupDefinition group)
    {
        var permission = group.GetPermissionOrNull(BasisPermissions.Integration.Default);
        if (permission != null)
        {
            permission.AddChild(AIPermissions.Integration.FastGpt, L("Permission:FastGpt"));
            permission.AddChild(AIPermissions.Integration.RagFlow, L("Permission:RagFlow"));
        }
    }

    private static LocalizableString L(string name)
    {
        return LocalizableString.Create<BasisResource>(name);
    }
}
