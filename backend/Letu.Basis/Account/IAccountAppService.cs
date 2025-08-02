using Letu.Basis.Account.Dtos;

namespace Letu.Basis.Account
{
    public interface IAccountAppService
    {
      
        /// <summary>
        /// 修改个人基本信息
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateUserInfoAsync(UserInfoUpdateInput dto);

        /// <summary>
        /// 修改个人密码
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<bool> UpdateUserPwdAsync(ChangePasswordInput dto);

        /// <summary>
        /// 获取用户权限信息
        /// </summary>
        /// <returns></returns>
        Task<UserAuthInfoOutput> GetUserAuthInfoAsync();
    }
}