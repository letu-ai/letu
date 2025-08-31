using Letu.Core.Applications;

namespace Letu.Basis.Admin.Employees.Dtos;

public class EmployeeSelectOption : SelectOption
{
    /// <summary>
    /// 员工编号
    /// </summary>
    public required string Code { get; set; }
}
