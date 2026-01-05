using Letu.Basis.Localization;
using Volo.Abp.Application.Services;

namespace Letu.AI.Workflows;

/// <summary>
/// AI 模块应用服务基类
/// </summary>
public abstract class AIAppService : ApplicationService
{
    protected AIAppService()
    {
        LocalizationResource = typeof(BasisResource);
        ObjectMapperContext = typeof(Letu.AI.LetuAIModule);
    }
}

