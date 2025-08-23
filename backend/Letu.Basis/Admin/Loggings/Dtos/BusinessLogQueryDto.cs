using Letu.Core.Applications;

namespace Letu.Basis.Admin.Loggings.Dtos
{
    public class BusinessLogQueryDto : PagedResultRequest
    {
        /// <summary>
        /// 业务类型
        /// </summary>
        public string? Type { get; set; }

        /// <summary>
        /// 业务子类型
        /// </summary>
        public string? SubType { get; set; }

        /// <summary>
        /// 操作内容
        /// </summary>
        public string? Content { get; set; }

        /// <summary>
        /// 账号
        /// </summary>
        public string? UserName { get; set; }
    }
}