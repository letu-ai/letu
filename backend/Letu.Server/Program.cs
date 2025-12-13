using Letu.Logging;
using Microsoft.AspNetCore.HttpsPolicy;
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

        builder.Host.UseLetuLogging(appSettings);
        builder.Host.UseAutofac();
        await builder.AddApplicationAsync<LetuServerModule>();

        var app = builder.Build();

        await app.InitializeApplicationAsync();

        await app.RunAsync();
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

