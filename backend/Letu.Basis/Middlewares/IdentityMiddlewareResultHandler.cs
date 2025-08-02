using Letu.Basis.Identity;
using Letu.Basis.SharedService;
using Letu.Core.Attributes;
using Letu.Shared.Consts;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authorization.Policy;
using System.Security.Claims;
using Volo.Abp.Security.Claims;

namespace Letu.Basis.Middlewares
{
    public class IdentityMiddlewareResultHandler : IAuthorizationMiddlewareResultHandler
    {
        private readonly AuthorizationMiddlewareResultHandler _defaultHandler = new();
        private readonly IdentitySharedService _identitySharedService;
        private readonly IIdentityAppService identityAppService;

        public IdentityMiddlewareResultHandler(IdentitySharedService identitySharedService, IIdentityAppService identityAppService)
        {
            _identitySharedService = identitySharedService;
            this.identityAppService = identityAppService;
        }

        public async Task HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)
        {
            if (context.User.Identity != null && context.User.Identity.IsAuthenticated)
            {
                //身份验证
                var subjectId = context.User.FindFirst(x => x.Type == AbpClaimTypes.UserId)?.Value;
                var sessionId = context.User.FindFirst(x => x.Type == AbpClaimTypes.SessionId)?.Value;

                var requestToken = context.Request.Headers["Authorization"].ToString().Replace(JwtBearerDefaults.AuthenticationScheme, "").Trim();
                var isValid = await identityAppService.ValidateTokenAsync(subjectId!, sessionId!, requestToken);
                if (!isValid)
                {
                    context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                    // TODO：返回未认证状态码
                    //await context.Response.WriteAsJsonAsync(new AppResponse<bool>(ErrorCode.NoAuth, "身份信息已过期，请重新登录").SetData(false));
                    return;
                }

                //检查权限
                var endpoint = context.GetEndpoint();
                var auth = endpoint?.Metadata.GetMetadata<HasPermissionAttribute>();
                var mustMain = endpoint?.Metadata.GetMetadata<MustMainPowerAttribute>();
                var hasPower = true;
                if (mustMain != null)
                {
                    hasPower = await _identitySharedService.UserIsFromMainDbAsync(subjectId!);
                }
                if (hasPower && auth != null)
                {
                    hasPower = await _identitySharedService.CheckPermissionAsync(subjectId!, auth.Code);
                }

                if (!hasPower)
                {
                    // TODO：返回未授权状态码
                    //await context.Response.WriteAsJsonAsync(new AppResponse<bool>(ErrorCode.Forbidden, "权限不足，请联系管理员").SetData(false));
                    context.Response.StatusCode = StatusCodes.Status403Forbidden;
                    return;
                }
            }

            await _defaultHandler.HandleAsync(next, context, policy, authorizeResult);
        }
    }
}