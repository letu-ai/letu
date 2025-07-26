using Letu.Core.Context;

namespace Letu.Core.AutoInject
{
    public abstract class ModuleBase
    {
        /// <summary>
        /// 模块加载顺序
        /// </summary>
        public virtual int Order { get; set; } = -1;

        public abstract void ConfigureServices(ServiceConfigurationContext context);

        public abstract void Configure(ApplicationInitializationContext context);
    }
}