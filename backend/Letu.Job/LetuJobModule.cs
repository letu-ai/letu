﻿using Letu.Job.Database;
using Letu.Repository;
using Microsoft.Extensions.DependencyInjection;
using Quartz;
using Quartz.Impl;
using Quartz.Impl.Matchers;
using Volo.Abp;
using Volo.Abp.Modularity;

namespace Letu.Job
{
    [DependsOn(
        typeof(LetuRepositoryModule)
        )]
    public class LetuJobModule : AbpModule
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            StdSchedulerFactory factory = new StdSchedulerFactory();
            IScheduler scheduler = factory.GetScheduler().ConfigureAwait(true).GetAwaiter().GetResult();
            context.Services.AddSingleton<IScheduler>(r => scheduler);
            context.Services.AddHostedService<JobInitHostService>();
            context.Services.AddScoped<IJobControl, JobService>();
        }

        public override void OnApplicationInitialization(ApplicationInitializationContext context)
        {
            //IScheduler? scheduler = context.ServiceProvider.GetService<IScheduler>();
            //if (scheduler != null)
            //{
            //    scheduler.JobFactory = new JobFactory(context.ServiceProvider);
            //    scheduler.ListenerManager.AddJobListener(new GlobalJobListener(context.ServiceProvider), EverythingMatcher<JobKey>.AllJobs());
            //    scheduler.Start().ConfigureAwait(true);
            //}
        }
    }
}