using Letu.Basis.Personal.Profiles.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Personal.Profiles
{
    public interface IProfileAppService
    {
        /// <summary>
        /// 获取个人基本信息
        /// </summary>
        /// <returns></returns>
        Task<ProfileOutput> GetProfileAsync();

        /// <summary>
        /// 修改个人基本信息
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<ProfileOutput> UpdateProfileAsync(ProfileUpdateInput input);

        Task<string> UploadAvatarAsync(AvatarUploadInput input);
        
        Task<(Stream?, string)> GetAvatarAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// 修改个人密码
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<bool> ChangePasswordAsync(ChangePasswordInput input);

        /// <summary>
        /// 获取个人登录日志列表
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<PagedResult<SecurityLogListDto>> GetSecurityLogsAsync(SecurityLogQueryInput input);

        /// <summary>
        /// 获取个人登录统计信息
        /// </summary>
        /// <returns></returns>
        Task<SecurityLogStatsDto> GetSecurityLogStatsAsync();
    }
}