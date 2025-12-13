using Letu.AI.Localization;
using Volo.Abp.Features;
using Volo.Abp.Localization;

namespace Letu.AI.Features
{
    /// <summary>
    /// 
    /// </summary>
    public class AIFeatureDefinitionProvider : FeatureDefinitionProvider
    {
        public override void Define(IFeatureDefinitionContext context)
        {
            var group = context.AddGroup(AIFeatures.GroupName, L("Feature:AI"));
            group.AddFeature(AIFeatures.Enable, defaultValue: "true", L("Enabled"), L("Feature:AI.Description"));
        }


        // 项目定义的本地化资源
        private static LocalizableString L(string name)
        {
            return LocalizableString.Create<AIResource>(name);
        }
    }
}
