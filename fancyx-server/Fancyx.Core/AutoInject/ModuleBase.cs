using Fancyx.Core.Context;

namespace Fancyx.Core.AutoInject
{
    public abstract class ModuleBase
    {
        public abstract void ConfigureServices(ServiceConfigurationContext context);

        public abstract void Configure(ApplicationInitializationContext context);
    }
}