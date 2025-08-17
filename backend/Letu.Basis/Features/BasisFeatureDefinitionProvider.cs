using Letu.Basis.Localization;
using Volo.Abp.Features;
using Volo.Abp.Localization;
using Volo.Abp.Validation.StringValues;

namespace Letu.Basis.Features
{
    /// <summary>
    /// 
    /// </summary>
    public class BasisFeatureDefinitionProvider : FeatureDefinitionProvider
    {
        public override void Define(IFeatureDefinitionContext context)
        {
            var group = context.AddGroup(BasisFeatures.GroupName, L("Feature:Basis"));
            group.AddFeature(BasisFeatures.Enable, defaultValue: "true", L("Enabled"), L("基础数据包括用户、角色、机构、字典等数据"));


            group.AddFeature("Basis.Feature2", defaultValue: "true", L("Feature 2"), L("Description for Feature 2"))
                .CreateChild("Basis.Feature2.1", defaultValue: "100", L("Feature 1"), L("Description for Feature 1"),
                valueType: new FreeTextStringValueType(new NumericValueValidator(3, 100)));
        }


        // 项目定义的本地化资源
        private static LocalizableString L(string name)
        {
            return LocalizableString.Create<BasisResource>(name);
        }
    }
}
