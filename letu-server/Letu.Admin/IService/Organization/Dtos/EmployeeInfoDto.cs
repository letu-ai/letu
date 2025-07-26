namespace Letu.Admin.IService.Organization.Dtos
{
    public class EmployeeInfoDto : EmployeeListDto
    {
        public string? UserName { get; set; }

        public string? NickName { get; set; }
    }
}