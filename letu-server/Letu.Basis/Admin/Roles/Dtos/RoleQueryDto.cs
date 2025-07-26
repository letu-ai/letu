namespace Letu.Basis.Admin.Roles.Dtos
{
    public class RoleQueryDto : PageSearch
    {
        /// <summary>
        /// 角色名
        /// </summary>
        public string? RoleName { get; set; }
    }
}