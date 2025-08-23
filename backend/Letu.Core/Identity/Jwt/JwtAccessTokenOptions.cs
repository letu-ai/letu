namespace Letu.Core.Identity.Jwt
{
    /// <summary>
    /// 授权配置
    /// </summary>
    [Obsolete("改用Setttings系统提供")]
    public class JwtAccessTokenOptions
    {
        public JwtAccessTokenOptions()
        {
        }


        /// <summary>
        /// Token过期时间（秒）
        /// 默认30分钟
        /// </summary>
        public int Expiration { get; set; } = 30 * 60;  // TODO: 改用Setttings系统提供

        /// <summary>
        /// RefreshToken过期时间（分钟）
        /// 默认30天
        /// </summary>
        public int RefreshTokenExpiration { get; set; } = 30 * 24 * 60; // TODO: 改用Setttings系统提供

        /// <summary>
        /// 是否允许多点登录
        /// 默认允许
        /// </summary>
        public bool AllowMultipleLogin { get; set; } = true; // TODO: 改用Setttings系统提供

    }
}
