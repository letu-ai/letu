using Letu.Abp;
using Letu.Basis;
using Letu.Basis.Middlewares;
using Letu.Core.JsonConverters;
using Letu.Core.Middlewares;
using Letu.Logging.Options;
using Letu.Shared.Consts;
using Medallion.Threading;
using Medallion.Threading.Redis;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.Extensions.Caching.StackExchangeRedis;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using StackExchange.Redis;
using System.Diagnostics;
using System.Threading.RateLimiting;
using Volo.Abp;
using Volo.Abp.AspNetCore.MultiTenancy;
using Volo.Abp.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Serilog;
using Volo.Abp.Authorization;
using Volo.Abp.Autofac;
using Volo.Abp.AutoMapper;
using Volo.Abp.Caching;
using Volo.Abp.Caching.StackExchangeRedis;
using Volo.Abp.DistributedLocking;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Emailing;
using Volo.Abp.EventBus;
using Volo.Abp.Modularity;

namespace Letu;

[DependsOn(
    typeof(AbpAspNetCoreMvcModule),
    typeof(AbpAspNetCoreMultiTenancyModule),
    typeof(AbpAuthorizationModule),
    typeof(AbpAutofacModule),
    typeof(AbpAutoMapperModule),
    typeof(AbpAspNetCoreSerilogModule),
    typeof(AbpEmailingModule),
    typeof(AbpEventBusModule),
    typeof(AbpDistributedLockingModule),
    typeof(AbpCachingStackExchangeRedisModule),
    typeof(LetuAbpFreeSqlModule),
    typeof(LetuBasisModule)
)]
public class LetuServerModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var configuration = context.Services.GetConfiguration();
        var services = context.Services;

        ConfigureDistributedCaching(services, configuration);
        ConfigureDistributedLock(services, configuration);
        ConfigureAuthentication(services, configuration);
        ConfigureCorsOrigins(services, configuration);
        ConfigureRateLimiter(services, configuration);
        ConfigureSwagger(services, configuration);
        ConfigureJsonOptions(services, configuration);
        ConfigureLogging(services, configuration);
    }

    private void ConfigureDistributedLock(IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<IDistributedLockProvider>(sp =>
        {
            var connection = ConnectionMultiplexer
                .Connect(configuration["Redis:Configuration"]);
            return new
                RedisDistributedSynchronizationProvider(connection.GetDatabase());
        });
    }

    private void ConfigureDistributedCaching(IServiceCollection services, IConfiguration configuration)
    {
        Configure<AbpDistributedCacheOptions>(options =>
        {
            options.KeyPrefix = "Letu:";
        });

        Configure<RedisCacheOptions>(options =>
        {
        });
    }

    private void ConfigureAuthentication(IServiceCollection services, IConfiguration configuration)
    {
        // 绑定配置
        var jwtOptions = configuration.GetSection("Jwt").Get<JwtOptions>();
        Debug.Assert(jwtOptions != null, "JwtOptions cannot be null. Please check your configuration.");

        Configure<JwtOptions>(configuration.GetSection("Jwt"));

        // 注册认证服务（使用验证参数）
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata = jwtOptions.Validation.RequireHttps;
                options.Authority = jwtOptions.Issuance.Issuer;
                options.Audience = jwtOptions.Issuance.Audience;

                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = jwtOptions.Validation.ValidateIssuer,
                    ValidIssuer = jwtOptions.Validation.ValidIssuer,
                    ValidateAudience = jwtOptions.Validation.ValidateAudience,
                    ValidAudience = jwtOptions.Validation.ValidAudience,
                    ValidateLifetime = jwtOptions.Validation.ValidateLifetime,
                    ClockSkew = TimeSpan.FromSeconds(jwtOptions.Validation.ClockSkewSeconds),
                    IssuerSigningKey = jwtOptions.GetValidationSecurityKey(),
                };
            });
    }


    private void ConfigureCorsOrigins(IServiceCollection services, IConfiguration configuration)
    {
        //配置跨域 
        services.AddCors(options =>
        {
            options.AddDefaultPolicy(builder =>
            {
                // 允许跨域访问的主机地址。
                string[] corsOrigins = configuration.GetSection("CorsOrigins").Get<string[]>() ?? Array.Empty<string>();
                corsOrigins = corsOrigins.Select(o => o.RemovePostFix("/"))
                    .ToArray();

                builder.WithAbpExposedHeaders()
                    .SetIsOriginAllowedToAllowWildcardSubdomains()
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    .AllowCredentials();

                builder.SetIsOriginAllowed(origin =>
                {
                    return corsOrigins.Contains("*") || corsOrigins.Contains(origin);
                });
            });
        });
    }

    private void ConfigureRateLimiter(IServiceCollection services, IConfiguration configuration)
    {
        //限流
        services.AddRateLimiter(options =>
        {
            // 防抖1秒内1次
            options.AddFixedWindowLimiter(RateLimiterConsts.DebouncePolicy, opt =>
            {
                opt.PermitLimit = 1;
                opt.Window = TimeSpan.FromSeconds(1);
                opt.QueueProcessingOrder = QueueProcessingOrder.OldestFirst;
            });

            // 滑动窗口限流
            options.AddSlidingWindowLimiter(RateLimiterConsts.SlidingPolicy, opt =>
            {
                opt.PermitLimit = 10;
                opt.Window = TimeSpan.FromSeconds(10);
                opt.SegmentsPerWindow = 2; // 分2段统计
            });

            // 自定义被限流时的响应
            options.OnRejected = async (context, cancellationToken) =>
            {
                context.HttpContext.Response.StatusCode = StatusCodes.Status200OK;
                context.HttpContext.Response.ContentType = "application/json";

                await context.HttpContext.Response.WriteAsJsonAsync("操作频繁，请稍后再试", cancellationToken);
            };
        });
    }

    private void ConfigureSwagger(IServiceCollection services, IConfiguration configuration)
    {
        //Swagger
        services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new OpenApiInfo { Title = "Letu Admin API", Version = "v1" });

            // 添加 JWT 认证支持到 Swagger
            var securityScheme = new OpenApiSecurityScheme
            {
                Name = "JWT Authentication",
                Description = "Enter JWT Bearer token **_only_**",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.Http,
                Scheme = "bearer", // 必须小写
                BearerFormat = "JWT",
                Reference = new OpenApiReference
                {
                    Id = JwtBearerDefaults.AuthenticationScheme,
                    Type = ReferenceType.SecurityScheme
                }
            };

            c.AddSecurityDefinition(securityScheme.Reference.Id, securityScheme);
            c.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                    {securityScheme, Array.Empty<string>()}
            });

        });
    }

    private void ConfigureJsonOptions(IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<JsonOptions>(options =>
        {
            options.JsonSerializerOptions.Converters.Add(new StringNullableJsonConverter());
            options.JsonSerializerOptions.Converters.Add(new StringJsonConverter());
            options.JsonSerializerOptions.Converters.Add(new DateTimeNullableJsonConverter());
            options.JsonSerializerOptions.Converters.Add(new DateTimeJsonConverter());
        });
    }

    private void ConfigureLogging(IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<LetuLoggingOption>(options =>
        {
            options.IgnoreExceptionTypes = [typeof(BusinessException), typeof(EntityNotFoundException)];
        });
    }

    public override void OnApplicationInitialization(ApplicationInitializationContext context)
    {
        var app = context.GetApplicationBuilder();
        var env = context.GetEnvironment();

        if (env.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Letu API V1");
            });
        }

        //TODO: 生产环境可以去掉
        app.UseMiddleware<DemonstrationModeMiddleware>();
        app.UseStaticFiles();
        app.UseRateLimiter(); // 启用限流中间件

        app.UseRouting();
        //处理ngnix代理的问题
        app.UseForwardedHeaders(new ForwardedHeadersOptions
        {
            ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost
        });
        //允许跨域
        app.UseCors();
        app.UseAuthentication();
        app.UseAuthorization();

        app.UseMiddleware<CurrentUserMiddleware>();

        app.UseConfiguredEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });


        ////定时任务
        //context.ServiceProvider.UseScheduler(sch =>
        //{
        //    sch.Schedule<NotificationJob>().EveryMinute().RunOnceAtStart();
        //});

        base.OnApplicationInitialization(context);
    }
}