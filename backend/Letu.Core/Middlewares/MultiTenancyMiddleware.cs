﻿using Letu.Core.Authorization;
using Letu.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Letu.Core.Middlewares
{
    public class MultiTenancyMiddleware
    {
        private readonly RequestDelegate next;
        private readonly ILogger<MultiTenancyMiddleware> logger;

        public MultiTenancyMiddleware(RequestDelegate next, ILogger<MultiTenancyMiddleware> logger)
        {
            this.next = next;
            this.logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                var hasTenantId = context.Request.Headers.TryGetValue("X-Tenant", out var tenant);
                var tenantId = tenant.ToString();
                if (!string.IsNullOrWhiteSpace(tenantId))
                {
                    var checker = (ITenantChecker?)context.RequestServices.GetRequiredService<ITenantChecker>();
                    if (checker != null)
                    {
                        if (!await checker.ExistTenantAsync(tenantId))
                        {
                            logger.LogWarning("租户{tenantId}不存在", tenantId);
                            await next(context);
                            return;
                        }
                    }
                    context.Features.Set<ICurrentTenant>(new CurrentTenant(tenantId));
                    TenantManager.SetCurrent(tenantId);
                }

                await next(context);
            }
            finally
            {
                TenantManager.SetCurrent("");
            }
        }
    }
}