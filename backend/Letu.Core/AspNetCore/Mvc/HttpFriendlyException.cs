using Microsoft.Extensions.Logging;
using Volo.Abp;
using Volo.Abp.ExceptionHandling;

namespace Letu.Core.AspNetCore.Mvc;

/// <summary>
/// 带有 HTTP 状态码的用户友好异常。
/// 在客户端直接显示异常消息。
/// </summary>
public class HttpFriendlyException : UserFriendlyException, IHasHttpStatusCode
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="message"></param>
    /// <param name="code">注意这个code是指错误码，不是http status</param>
    /// <param name="details"></param>
    /// <param name="innerException"></param>
    /// <param name="logLevel"></param>
    public HttpFriendlyException(string message, string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
        : base(message, code, details, innerException, logLevel)
    {
        HttpStatusCode = 403; //
    }

    public int HttpStatusCode { get; set; }

    public static HttpFriendlyException NotFound(string message = "Not Found", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 404
        };
    }

    public static HttpFriendlyException BadRequest(string message = "Bad Request", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 400
        };
    }

    public static HttpFriendlyException Unauthorized(string message = "Unauthorized", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 401
        };
    }

    public static HttpFriendlyException Forbidden(string message = "Forbidden", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 403
        };
    }

    public static HttpFriendlyException MethodNotAllowed(string message = "Method Not Allowed", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 405
        };
    }

    public static HttpFriendlyException Conflict(string message = "Conflict", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Warning)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 409
        };
    }

    public static HttpFriendlyException InternalServerError(string message = "Internal Server Error", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Error)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 500
        };
    }

    public static HttpFriendlyException ServiceUnavailable(string message = "Service Unavailable", string? code = null, string? details = null, Exception? innerException = null, LogLevel logLevel = LogLevel.Error)
    {
        return new HttpFriendlyException(message, code, details, innerException, logLevel)
        {
            HttpStatusCode = 503
        };
    }
}
