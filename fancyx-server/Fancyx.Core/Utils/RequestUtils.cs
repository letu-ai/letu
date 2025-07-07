using Fancyx.Core.Authorization;
using Fancyx.Core.Interfaces;
using IP2Region.Net.XDB;
using Microsoft.AspNetCore.Http;
using System.Net;

namespace Fancyx.Core.Utils
{
    public class RequestUtils
    {
        public static ICurrentUser ResolveUser(HttpContext? context)
        {
            return context?.Features.Get<CurrentUser>() ?? CurrentUser.Default();
        }

        public static ICurrentTenant ResolveTenant(HttpContext? context)
        {
            return context?.Features.Get<CurrentTenant>() ?? new CurrentTenant(null);
        }

        public static string? GetIp(HttpContext context)
        {
            var header = context.Request.Headers;
            string? ip;
            if (header.TryGetValue("X-Real-IP", out var realIp))
            {
                ip = realIp;
            }
            else if (header.TryGetValue("X-Forwarded-For", out var forwardFor))
            {
                ip = forwardFor;
            }
            else
            {
                ip = context.Connection.RemoteIpAddress?.ToString();
            }
            return ip;
        }

        public static string? GetUserAgent(HttpContext context)
        {
            return context.Request.Headers.UserAgent;
        }

        public static string? ResolveBrowser(string? userAgent)
        {
            var parser = UAParser.Parser.GetDefault().Parse(userAgent);
            return parser.String;
        }

        public static string? ResolveAddress(string? ip)
        {
            if (string.IsNullOrWhiteSpace(ip) || !IsValidIP(ip)) return null;

            //拿到地址示例：中国|0|重庆|重庆市|移动
            var address = ResolveAddress(new Searcher(CachePolicy.Content, Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ip2region.xdb")).Search(ip!));
            if (string.IsNullOrWhiteSpace(address)) return string.Empty;
            if (address.Contains("0|0|0"))
            {
                return "未知";
            }
            string[] strs = address.Split('|');
            if (strs.Length >= 4)
            {
                return string.Concat(strs[0], strs[2], strs[3]);
            }
            else if (strs.Length == 1)
            {
                return strs[0];
            }
            return string.Empty;
        }

        public static bool IsValidIP(string ipString)
        {
            return IPAddress.TryParse(ipString, out IPAddress? address) &&
                   address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork;
        }
    }
}