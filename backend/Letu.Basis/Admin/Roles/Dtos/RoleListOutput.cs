namespace Letu.Basis.Admin.Roles.Dtos
{
    public class RoleListOutput
    {
        /// <summary>
        /// 角色ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 角色名
        /// </summary>
        public required string Name { get; set; }

        /// <summary>
        /// 备注
        /// </summary>
        public string? Remark { get; set; }

        public DateTime CreationTime { get; set; }

        public bool IsEnabled { get; set; }
    }
}