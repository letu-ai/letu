using Letu.Abp;
using Letu.AI;
using Letu.Basis;
using Letu.Basis.Middlewares;
using Letu.Core.Identity.Jwt;
using Letu.Core.JsonConverters;
using Letu.Core.MultiTenancy;
using Letu.Server;
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
using Volo.Abp.AspNetCore.Mvc.AntiForgery;
using Volo.Abp.AspNetCore.Serilog;
using Volo.Abp.Authorization;
using Volo.Abp.Autofac;
using Volo.Abp.AutoMapper;
using Volo.Abp.BlobStoring;
using Volo.Abp.BlobStoring.FileSystem;
using Volo.Abp.Caching;
using Volo.Abp.Caching.StackExchangeRedis;
using Volo.Abp.DistributedLocking;
using Volo.Abp.Emailing;
using Volo.Abp.EventBus;
using Volo.Abp.Modularity;
using Volo.Abp.Security.Claims;

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
    typeof(AbpBlobStoringFileSystemModule),
    typeof(LetuAbpFreeSqlModule),
    typeof(LetuBasisModule),
    typeof(LetuAIModule)
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
        ConfigureAntiForgery();
        ConfigureRateLimiter(services, configuration);
        ConfigureSwagger(services, configuration);
        ConfigureJsonOptions(services, configuration);
        ConfigureBlobStoring();
        ConfigureDynamicClaims();
    }

    private void ConfigureDistributedLock(IServiceCollection services, IConfiguration configuration)
    {
        services.AddSingleton<IDistributedLockProvider>(sp =>
        {
            var redisConfiguration = configuration["Redis:Configuration"];
            if (string.IsNullOrWhiteSpace(redisConfiguration))
            {
                throw new Exception("Redis 配置不能为空，请检查配置文件。");
            }

            var connection = ConnectionMultiplexer
                .Connect(redisConfiguration);
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

        // 注册认证服务，支持从 Header 和 Cookie 中读取 JWT Token
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddScheme<JwtBearerOptions, JwtCookieAuthenticationHandler>(JwtBearerDefaults.AuthenticationScheme, options =>
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
                string[] allowedOrigins = (configuration.GetSection("CorsOrigins").Get<string[]>() ?? Array.Empty<string>())
                                            .Select(o => o.RemovePostFix("/"))
                                            .ToArray();

                builder.WithAbpExposedHeaders()
                    .WithOrigins(allowedOrigins)
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    .AllowCredentials();

                // CNB 云原生开发环境，允许任意来源跨域访问。
                if (configuration["CNB_VSCODE_PROXY_URI"] != null)
                    builder.SetIsOriginAllowed(_ => true);
            });
        });
    }

    private void ConfigureAntiForgery()
    {
        Configure<AbpAntiForgeryOptions>(options =>
        {
            // 默认是全局自动Antiforgery验证，如果临时想全局验证，可以设置为false。
            // 如果某个API要设置Cookie，可以在Action或Controller上加[AutoValidateAntiforgeryToken]特性
            // 参见 Letu.Basis.Controllers.Accont.IdentityController.Login
            // options.AutoValidate = true;
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

    private void ConfigureBlobStoring()
    {
        Configure<AbpBlobStoringOptions>(options =>
        {
            options.Containers.ConfigureDefault(container =>
            {
                container.UseFileSystem(fileSystem =>
                {
                    fileSystem.BasePath = Path.Join(Program.GetProgramDirectory(), "blobs");
                });
            });
        });
    }

    private void ConfigureDynamicClaims()
    {
        Configure<AbpClaimsPrincipalFactoryOptions>(options =>
        {
            options.IsDynamicClaimsEnabled = true; //set it "true" to enable "Dynamic Claims" or "false" to disable it.
        });
    }

    public override Task OnApplicationInitializationAsync(ApplicationInitializationContext context)
    {
        var app = context.GetApplicationBuilder();
        var env = context.GetEnvironment();
        var configuration = context.ServiceProvider.GetRequiredService<IConfiguration>();

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

        // 在CNB云原生开发环境中使用CNB的跨域策略。
        if (env.IsDevelopment() && configuration["CNB_VSCODE_PROXY_URI"] != null)
            app.UseSetOriginFromReferer();

        app.UseCors();
        app.UseAuthentication();
        if (MultiTenancyConsts.IsEnabled)
        {
            app.UseMultiTenancy();
        }
        app.UseUnitOfWork();
        app.UseDynamicClaims();
        app.UseAuthorization();

        app.UseConfiguredEndpoints(endpoints =>
        {
            endpoints.MapControllers();
            // 优先处理未匹配的API请求
            endpoints.MapFallback("/api/{*any}", context =>
            {
                context.Response.StatusCode = StatusCodes.Status404NotFound;
                return Task.CompletedTask;
            });

            // 处理其他请求
            endpoints.MapFallbackToFile("index.html");
        });



        return base.OnApplicationInitializationAsync(context);
    }
}