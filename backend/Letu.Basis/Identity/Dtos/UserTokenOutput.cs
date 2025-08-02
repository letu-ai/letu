namespace Letu.Basis.Identity.Dtos
{
    public class UserTokenOutput
    {
        /// <summary>
        /// Token类型，固定为“Bearer”
        /// </summary>
        public string Type { get; } = "Bearer";

        /// <summary>
        /// 访问token
        /// </summary>
        public required string AccessToken { get; set; }

        /// <summary>
        /// 刷新token
        /// </summary>
        public string? RefreshToken { get; set; }

        /// <summary>
        /// Token过期的UTC时间
        /// </summary>
        public DateTimeOffset ExpiredTime { get; set; }
    }
} 