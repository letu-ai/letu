using Microsoft.Extensions.DependencyInjection;
using Quartz;
using Quartz.Spi;

namespace Letu.Job
{
    // TODO: 使用abp的定时任务替换
    //public class JobFactory : IJobFactory
    //{
    //    private readonly IServiceProvider _serviceProvider;

    //    public JobFactory(IServiceProvider serviceProvider)
    //    {
    //        _serviceProvider = serviceProvider;
    //    }

    //    public IJob NewJob(TriggerFiredBundle bundle, IScheduler scheduler)
    //    {
    //        return (_serviceProvider.GetRequiredService(bundle.JobDetail.JobType) as IJob)!;
    //    }

    //    public void ReturnJob(IJob job) { }
    //}
}