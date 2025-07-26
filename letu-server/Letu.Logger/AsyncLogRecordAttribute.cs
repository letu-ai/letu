using DotNetCore.CAP;
using Letu.Core.AutoInject;
using Letu.Core.Utils;
using Letu.Logger.Consts;
using Letu.Logger.Message;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace Letu.Logger
{
    /// <summary>
    /// ������־��¼������ҵ�񷽷��ϣ�ֻ�ʺ��첽������
    /// </summary>
    public sealed class AsyncLogRecordAttribute : AsyncAopAttributeBase
    {
        public string Type { get; init; }
        public string SubType { get; init; }
        public string BizNo { get; init; }
        public string Content { get; init; }

        public AsyncLogRecordAttribute(string type, string subType, string bizNo, string content) : base(true)
        {
            Type = type;
            SubType = subType;
            BizNo = bizNo;
            Content = content;
        }

        public override async Task OnAfterAsync()
        {
            var eventBus = ServiceProvider.GetService<ICapPublisher>();
            if (eventBus == null) return;
            var msg = new LogRecordMessage();
            try
            {
                var map = LogRecordContext.GetVariables().ToDictionary();
                msg.Type = TemplateUtils.Render(Type!, map);
                msg.SubType = TemplateUtils.Render(SubType!, map);
                msg.BizNo = TemplateUtils.Render(BizNo!, map);
                msg.Content = TemplateUtils.Render(Content!, map);
                msg.CreationTime = DateTime.Now;
                var httpContext = ServiceProvider.GetService<IHttpContextAccessor>()?.HttpContext;
                if (httpContext != null)
                {
                    var currentUser = RequestUtils.ResolveUser(httpContext);
                    var currentTenant = RequestUtils.ResolveTenant(httpContext);
                    msg.UserId = currentUser.Id;
                    msg.UserName = currentUser.UserName;
                    msg.TenantId = currentTenant.TenantId;
                    msg.Ip = RequestUtils.GetIp(httpContext);
                    msg.UserAgent = RequestUtils.GetUserAgent(httpContext);
                    msg.TraceId = Activity.Current?.TraceId.ToString();
                }
                LogRecordContext.Dispose();
                await eventBus.PublishAsync(EventBusTopicConsts.LOG_RECORD_EVENT, msg);
            }
            catch (Exception ex)
            {
                var logger = ServiceProvider.GetService<ILogger<AsyncLogRecordAttribute>>();
                logger?.LogError(ex, "������־[{type}]�����쳣", msg.Type);
            }
        }

        public override Task OnBeforeAsync()
        {
            LogRecordContext.Init();
            return Task.CompletedTask;
        }
    }
}