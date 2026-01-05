using Serilog.Events;
using Serilog;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;

namespace Letu.Logging;

public static class LoggingExtension
{
    public static void UseLetuLogging(this ConfigureHostBuilder builder, IConfiguration configuration)
    {
        string logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs", DateTime.Now.ToString("yyyy-MM"));
        Log.Logger = new LoggerConfiguration()
            .ReadFrom.Configuration(configuration)
            .Enrich.FromLogContext()
            .WriteTo.Async(c =>
                c.File(Path.Combine(logPath, "log.txt"),
                fileSizeLimitBytes: 100 * 1024 * 1024,      //日志文件超过100M自动分块
                rollOnFileSizeLimit: true,
                rollingInterval: RollingInterval.Day,           //每天切换一个文件
                retainedFileTimeLimit: TimeSpan.FromDays(7),    //日志保留天数
                outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level:u3}] {Message:lj}{NewLine}{Exception}"
            ))
            .WriteTo.Logger(lc => lc.Filter.ByIncludingOnly(e => e.Level >= LogEventLevel.Error)
            .WriteTo.File(Path.Combine(logPath, "error.txt"), rollingInterval: RollingInterval.Day))
            .WriteTo.Async(c => c.Console())
            .CreateLogger();
        builder.UseSerilog();
    }
}