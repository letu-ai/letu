﻿using DotNetCore.CAP;
using Letu.Core.Utils;
using Letu.Logger.Consts;
using Letu.Logger.Entities;
using Letu.Logger.Message;

namespace Letu.Logger
{
    public class LoggerCapSubscriber : ICapSubscribe
    {
        private readonly IFreeSql _freeSql;

        public LoggerCapSubscriber(IFreeSql freeSql)
        {
            _freeSql = freeSql;
        }

        [CapSubscribe(EventBusTopicConsts.LOG_RECORD_EVENT)]
        public async Task LogRecord(LogRecordMessage message)
        {
            var entity = new LogRecordDO
            {
                Type = message.Type,
                SubType = message.SubType,
                BizNo = message.BizNo,
                Content = message.Content,
                Ip = message.Ip,
                Browser = RequestUtils.ResolveBrowser(message.UserAgent),
                UserId = message.UserId,
                UserName = message.UserName,
                TraceId = message.TraceId,
                CreatorId = message.UserId,
                TenantId = message.TenantId,
                CreationTime = message.CreationTime
            };

            await _freeSql.Insert(entity).ExecuteAffrowsAsync();
        }

        [CapSubscribe(EventBusTopicConsts.API_ACCESS_LOG_EVENT)]
        public async Task ApiAccessLog(ApiAccessLogMessage message)
        {
            var entity = new ApiAccessLogDO
            {
                Path = message.Path,
                Method = message.Method,
                RequestTime = message.RequestTime,
                OperateType = message.OperateType,
                OperateName = message.OperateName,
                QueryString = message.QueryString,
                RequestBody = message.RequestBody,
                ResponseBody = message.ResponseBody,
                ResponseTime = message.ResponseTime,
                Duration = message.Duration,
                Ip = message.Ip,
                Browser = RequestUtils.ResolveBrowser(message.UserAgent),
                UserId = message.UserId,
                UserName = message.UserName,
                TraceId = message.TraceId,
                CreatorId = message.UserId,
                TenantId = message.TenantId,
            };

            await _freeSql.Insert(entity).ExecuteAffrowsAsync();
        }

        [CapSubscribe(EventBusTopicConsts.EXCEPTION_LOG_EVENT)]
        public async Task ExceptionLog(ExceptionLogMessage message)
        {
            var entity = new ExceptionLogDO()
            {
                RequestPath = message.RequestPath,
                RequestMethod = message.RequestMethod,
                ExceptionType = message.ExceptionType,
                Message = message.Message,
                StackTrace = message.StackTrace,
                InnerException = message.InnerException,
                Ip = message.Ip,
                Browser = RequestUtils.ResolveBrowser(message.UserAgent),
                UserId = message.UserId,
                UserName = message.UserName,
                TraceId = message.TraceId,
                CreatorId = message.UserId,
                TenantId = message.TenantId
            };

            await _freeSql.Insert(entity).ExecuteAffrowsAsync();
        }
    }
}