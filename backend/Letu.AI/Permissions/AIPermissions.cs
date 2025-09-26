using Letu.Basis.Permissions;
using Volo.Abp.Reflection;

namespace Letu.AI.Permissions;

public static class AIPermissions
{
    // 定义权限常量。

    public const string AIGroupName = "AI";

    // 系统设置


    // 这里时扩展基础模块的系统集成权限，所以用的基础模块的权限常量。
    public static class Integration{

        /// <summary>
        /// 第三方集成设置
        /// </summary>
        public const string Default = BasisPermissions.Integration.Default;

        /// <summary>
        /// FastGPT
        /// </summary>
        public const string FastGpt = Default + ".FastGpt";

        /// <summary>
        /// RAGFlow
        /// </summary>
        public const string RagFlow = Default + ".RagFlow";
    }

    public static string[] GetAll()
    {
        return ReflectionHelper.GetPublicConstantsRecursively(typeof(AIPermissions));
    }
}
