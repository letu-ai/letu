using Letu.Basis.Localization;
using Letu.Logging.BusinessLogs;
using Volo.Abp.Application.Services;

namespace Letu.Basis;

public abstract class BasisAppService : ApplicationService
{
    protected IBusinessLogManager BusinessLogManager => LazyServiceProvider.LazyGetRequiredService<IBusinessLogManager>();

    protected BasisAppService()
    {
        LocalizationResource = typeof(BasisResource);
        ObjectMapperContext = typeof(LetuBasisModule);
    }
}
