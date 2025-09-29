using Letu.Logging;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.InteropServices;

namespace Letu.Server;

public class Program
{
    [AllowNull]
    private static IConfigurationRoot appSettings => LoadAppSettings();

    public static async Task Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Host.UseLetuLogging();
        builder.Host.UseAutofac();
        if (builder.Environment.IsEnvironment("Docker"))
        {
            // 添加此代码块显式禁用 HTTPS
            builder.WebHost.ConfigureKestrel(serverOptions =>
            {
                // 清除所有默认端点配置
                serverOptions.ConfigureEndpointDefaults(options =>
                {

                });
                serverOptions.ListenAnyIP(80); // 监听所有 IP 的 80 端口

            });

            // 添加此配置禁用 HTTPS 重定向
            builder.Services.Configure<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions>(options =>
            {
                options.HttpsPort = null;
            });
        }

        await builder.AddApplicationAsync<LetuServerModule>();

        var app = builder.Build();

        AddListenUrls(app.Urls);
        await app.InitializeApplicationAsync();

        await app.RunAsync();
    }

    public static void AddListenUrls(ICollection<string> urls)
    {
        var eps = appSettings.GetValue<string>("Server:WebEndPoints");
        if (eps != null)
        {
            foreach (var ep in eps.Split(';', StringSplitOptions.RemoveEmptyEntries))
            {
                urls.Add(ep);
            }
        }
    }

    /// <summary>
    /// 获取主进程所在目录。
    /// </summary>
    /// <returns></returns>
    public static string GetProgramDirectory()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            return Path.GetDirectoryName(Environment.ProcessPath) ?? throw new InvalidOperationException("在Windows环境中获取当前进程路径失败。");
        else
            return AppDomain.CurrentDomain.BaseDirectory;
    }

    private static IConfigurationRoot LoadAppSettings()
    {
        return new ConfigurationBuilder()
           .SetBasePath(GetProgramDirectory())
           .AddJsonFile("appsettings.json")
           .AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")}.json", true)
           .AddEnvironmentVariables()
           .Build();
    }
}

