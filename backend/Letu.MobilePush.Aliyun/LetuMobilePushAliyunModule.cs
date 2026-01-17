using Letu.Basis;
using Letu.MobilePush;
using Volo.Abp.Modularity;

namespace Letu.MobilePush.Aliyun;

[DependsOn(
    typeof(LetuMobilePushModule),
    typeof(LetuBasisModule)
    )]
public class LetuMobilePushAliyunModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        // 服务通过依赖注入自动注册
        // AliyunMobilePushService 和 AliyunPushClientFactory 都实现了 ITransientDependency
    }
}