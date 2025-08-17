using Letu.Basis.Localization;
using Volo.Abp.Application.Services;

namespace Letu.Basis;

public abstract class BasisAppService : ApplicationService
{
    protected BasisAppService()
    {
        LocalizationResource = typeof(BasisResource);
        ObjectMapperContext = typeof(LetuBasisModule);
    }
}
