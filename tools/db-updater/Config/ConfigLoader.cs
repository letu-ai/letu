using Microsoft.Extensions.Configuration;

namespace DbCompareTool.Config;

public static class ConfigLoader
{
    public static ComparisonConfig Load()
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: false)
            .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: false)
            .Build();

        var config = new ComparisonConfig();

        // 加载连接字符串
        var sourceConn = configuration.GetSection("ConnectionStrings:Source").Value;
        var targetConn = configuration.GetSection("ConnectionStrings:Target").Value;

        if (string.IsNullOrEmpty(sourceConn) || string.IsNullOrEmpty(targetConn))
        {
            throw new InvalidOperationException("ConnectionStrings 配置不完整");
        }

        // 解析连接字符串到配置对象
        config.Source = ParseConnectionString(sourceConn);
        config.Target = ParseConnectionString(targetConn);

        // 加载其他配置
        configuration.GetSection("Comparison").Bind(config.Options);
        configuration.GetSection("Filter").Bind(config.Filter);
        configuration.GetSection("Output").Bind(config.Output);

        return config;
    }

    private static ConnectionConfig ParseConnectionString(string connectionString)
    {
        var config = new ConnectionConfig();

        var parts = connectionString.Split(';', StringSplitOptions.RemoveEmptyEntries);
        foreach (var part in parts)
        {
            var keyValue = part.Split('=', 2);
            if (keyValue.Length != 2) continue;

            var key = keyValue[0].Trim().ToLowerInvariant();
            var value = keyValue[1].Trim();

            switch (key)
            {
                case "host":
                    config.Host = value;
                    break;
                case "port":
                    if (int.TryParse(value, out var port))
                        config.Port = port;
                    break;
                case "database":
                    config.Database = value;
                    break;
                case "username":
                    config.Username = value;
                    break;
                case "password":
                    config.Password = value;
                    break;
            }
        }

        return config;
    }
}
