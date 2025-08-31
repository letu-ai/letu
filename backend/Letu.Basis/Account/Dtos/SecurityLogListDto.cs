namespace Letu.Basis.Account.Dtos
{
    public class SecurityLogListDto
    {
        /// <summary>
        /// ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// IP地址
        /// </summary>
        public string? Ip { get; set; }

        /// <summary>
        /// 登录地址
        /// </summary>
        public string? Location { get; set; }

        /// <summary>
        /// 浏览器
        /// </summary>
        public string? Browser { get; set; }

        /// <summary>
        /// 操作系统
        /// </summary>
        public string? Os { get; set; }

        /// <summary>
        /// 设备信息
        /// </summary>
        public string? Device { get; set; }

        /// <summary>
        /// 是否成功
        /// </summary>
        public bool IsSuccess { get; set; }

        /// <summary>
        /// 操作消息
        /// </summary>
        public string? OperationMsg { get; set; }

        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreationTime { get; set; }
    }
}