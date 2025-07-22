namespace Fancyx.Admin.Middlewares
{
    public class DemonstrationModeMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IConfiguration _configuration;

        public DemonstrationModeMiddleware(RequestDelegate next, IConfiguration configuration)
        {
            _configuration = configuration;
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var demoRs = IsDemonstrationMode(context);
            if (!demoRs.EnsureSuccess())
            {
                await context.Response.WriteAsJsonAsync(demoRs);
                return;
            }

            await _next(context);
        }

        /// <summary>
        /// 是否演示模式
        /// </summary>
        /// <returns></returns>
        private AppResponse<bool> IsDemonstrationMode(HttpContext context)
        {
            var isEnabled = bool.Parse(_configuration["App:DemonstrationMode"]!);
            var httpMethod = context.Request.Method.ToLower();
            var requestPath = context.Request.Path.Value?.ToLower();
            var isWhite = !string.IsNullOrWhiteSpace(requestPath) && (requestPath.Contains("login") || requestPath.Contains("account/signout") || requestPath.Contains("account/refreshtoken") || requestPath.Contains("api/mqtt"));

            return isEnabled && !IsIgnoreHttpMethod(httpMethod) && !isWhite ? Result.Fail("演示模式（appsettings中配置\"DemonstrationMode\"可关闭此模式），不允许操作") : Result.Ok();
        }

        /// <summary>
        /// 是否忽略请求
        /// </summary>
        /// <param name="method">请求方法</param>
        /// <returns></returns>
        private bool IsIgnoreHttpMethod(string method) => method == "get" || method == "option";
    }
}