using Letu.Cap;
using Letu.Core.AutoInject;
using Letu.Core.Context;
using Letu.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;

namespace Letu.Logger
{
    [DependsOn(
        typeof(LetuCapModule),
        typeof(LetuRepositoryModule)
        )]
    public class LetuLoggerModule : ModuleBase
    {
        public override void Configure(ApplicationInitializationContext context)
        {
        }

        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            context.Services.Configure<MvcOptions>(options =>
            {
                options.Filters.Add<ExceptionLogFilter>(99);
            });
        }
    }
}