namespace Letu.Basis.Personal.Profiles.Dtos
{
    public class SecurityLogStatsDto
    {
        /// <summary>
        /// 今日登录次数
        /// </summary>
        public int TodayLoginCount { get; set; }

        /// <summary>
        /// 最近登录IP
        /// </summary>
        public string? RecentLoginIp { get; set; }

        /// <summary>
        /// 异常登录次数
        /// </summary>
        public int AbnormalLoginCount { get; set; }

        /// <summary>
        /// 总登录次数
        /// </summary>
        public int TotalLoginCount { get; set; }
    }
}