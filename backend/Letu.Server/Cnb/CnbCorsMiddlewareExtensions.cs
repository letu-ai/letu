using Microsoft.AspNetCore.Cors.Infrastructure;

namespace Microsoft.AspNetCore.Builder;

/// <summary>
/// The <see cref="IApplicationBuilder"/> extensions for adding CORS middleware support.
/// </summary>
public static class CorsMiddlewareExtensions
{
    // CNB代理会修改Origin头，我们使用Referer头还原。
    public static IApplicationBuilder UseSetOriginFromReferer(this IApplicationBuilder app)
    {
        app.Use((context, next) =>
        {
            if (context.Request.Headers.ContainsKey(CorsConstants.Origin))
            {
                var referer = context.Request.Headers.Referer.FirstOrDefault();
                if (referer != null)
                {
                    var origin = referer.RemovePostFix("/");
                    context.Request.Headers.Origin = origin;
                }
            }

            return next();
        });

        return app;
    }
}