namespace Letu.Basis.Admin.Employees.Dtos
{
    public class EmployeeInfoDto : EmployeeListOutput
    {
        public string? UserName { get; set; }

        public string? NickName { get; set; }
    }
}