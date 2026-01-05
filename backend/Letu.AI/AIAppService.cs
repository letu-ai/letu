using Letu.AI.Localization;
using Letu.Logging.BusinessLogs;
using Volo.Abp.Application.Services;

namespace Letu.AI;

public abstract class AIAppService : ApplicationService
{
    protected IBusinessLogManager BusinessLogManager => LazyServiceProvider.LazyGetRequiredService<IBusinessLogManager>();

    protected AIAppService()
    {
        LocalizationResource = typeof(AIResource);
        ObjectMapperContext = typeof(LetuAIModule);
    }
}
