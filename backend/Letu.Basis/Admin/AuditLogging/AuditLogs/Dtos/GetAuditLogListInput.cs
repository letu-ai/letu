using System.ComponentModel.DataAnnotations;
using System.Net;
using Volo.Abp.Application.Dtos;
using Volo.Abp.AuditLogging;
using Volo.Abp.Validation;

namespace Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;

public class GetAuditLogListInput : PagedAndSortedResultRequestDto
{
    /// <summary>
    /// 开始时间
    /// </summary>
    public DateTime? StartTime { get; set; }

    /// <summary>
    /// 结束时间
    /// </summary>
    public DateTime? EndTime { get; set; }

    [DynamicStringLength(typeof(AuditLogConsts), nameof(AuditLogConsts.MaxUrlLength))]
    public string? Url { get; set; }

    /// <summary>
    /// 用户Id
    /// </summary>
    public Guid? UserId { get; set; }

    [DynamicStringLength(typeof(AuditLogConsts), nameof(AuditLogConsts.MaxUserNameLength))]
    public string? UserName { get; set; }

    public string? ApplicationName { get; set; }

    public string? CorrelationId { get; set; }

    [DynamicStringLength(typeof(AuditLogConsts), nameof(AuditLogConsts.MaxHttpMethodLength))]
    public string? HttpMethod { get; set; }

    public HttpStatusCode? HttpStatusCode { get; set; }

    public int? MaxExecutionDuration { get; set; }

    public int? MinExecutionDuration { get; set; }
    public string? ClientId { get; set; }

    public string? ClientIpAddress { get; set; }

    public bool? HasException { get; set; }
}
