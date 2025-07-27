﻿using DotNetCore.CAP;
using Letu.Core.AutoInject;
using Letu.Core.Context;
using Letu.Core.Utils;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;
using StackExchange.Redis;
using System.Reflection;

namespace Letu.Cap
{
    public class LetuCapModule : ModuleBase
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            context.Services.AddCap(x =>
            {
                x.UseRedis(opt =>
                {
                    opt.Configuration = ConfigurationOptions.Parse(context.Configuration["Cap:RedisConnection"]!);
                });
                x.UsePostgreSql(opt =>
                {
                    opt.Schema = "cap";
                    opt.DataSource = NpgsqlDataSource.Create(context.Configuration.GetConnectionString("Default")!);
                });
#if DEBUG
                x.UseDashboard();
#endif
            });

            //自动以Scoped方式注册ICapSubscribe实现类
            var baseType = typeof(ICapSubscribe);
            foreach (var assembly in ReflectionUtils.AllAssemblies)
            {
                IEnumerable<TypeInfo> types = assembly.DefinedTypes.Where(x => !x.IsAbstract && x.IsClass && !x.IsSealed && x != baseType && x.IsAssignableTo(baseType));
                foreach (var type in types)
                {
                    context.Services.AddScoped(type);
                }
            }
        }

        public override void Configure(ApplicationInitializationContext app)
        {
        }
    }
}