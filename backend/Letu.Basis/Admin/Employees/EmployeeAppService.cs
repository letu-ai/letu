using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Users;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Utils;
using Letu.Logging.BusinessLogs;
using Letu.Repository;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Uow;

namespace Letu.Basis.Admin.Employees;

public class EmployeeAppService : BasisAppService, IEmployeeAppService
{
    private readonly IFreeSqlRepository<Employee> employeeRepository;
    private readonly IFreeSqlRepository<Department> _deptRepository;
    private readonly IFreeSqlRepository<User> _userRepository;

    public EmployeeAppService(IFreeSqlRepository<Employee> employeeRepository, IFreeSqlRepository<Department> deptRepository, IFreeSqlRepository<Position> orgPositionRepository
        , IUserAppService userService, IFreeSqlRepository<User> userRepository)
    {
        this.employeeRepository = employeeRepository;
        _deptRepository = deptRepository;
        _userRepository = userRepository;
    }

    [BusinessLog("员工管理", BusinessOperateType.Create, "新增员工{{Name}}")]
    [UnitOfWork]
    public async Task<bool> AddEmployeeAsync(EmployeeCreateOrUpdateInput dto)
    {
        if (await employeeRepository.Select.AnyAsync(x => x.Code.ToLower() == dto.Code.ToLower()))
        {
            throw HttpFriendlyException.BadRequest($"工号{dto.Code}已存在");
        }
        if (!string.IsNullOrEmpty(dto.IdNo) && await employeeRepository.Select.AnyAsync(x => dto.IdNo.Equals(x.IdNo, StringComparison.OrdinalIgnoreCase)))
        {
            throw HttpFriendlyException.BadRequest($"身份证号{dto.IdNo}已存在");
        }

        var entity = ObjectMapper.Map<EmployeeCreateOrUpdateInput, Employee>(dto);
        await employeeRepository.InsertAsync(entity);
        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddEntityId(entity.Id);

        return true;
    }

    [BusinessLog("员工管理", BusinessOperateType.Delete, "删除员工")]
    public async Task<bool> DeleteEmployeeAsync(Guid id)
    {
        await employeeRepository.DeleteAsync(x => x.Id == id);
        BusinessLogManager.Current?.AddEntityId(id);

        return true;
    }

    public async Task<PagedResult<EmployeeListOutput>> GetEmployeePagedListAsync(EmployeeListInput dto)
    {
        var list = await employeeRepository.Select
            .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Code!.Contains(dto.Keyword!) || x.Name!.Contains(dto.Keyword!))
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync<EmployeeListOutput>();

        return new PagedResult<EmployeeListOutput>(dto) { Items = list, TotalCount = total };
    }

    public async Task<List<EmployeeCreateOrUpdateInput>> GetEmployeeListAsync(EmployeeListInput dto)
    {
        return await employeeRepository.Where(x => x.Status == 1)
            .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name!.Contains(dto.Keyword!))
            .ToListAsync<EmployeeCreateOrUpdateInput>();
    }

    [BusinessLog("员工管理", BusinessOperateType.Update, "更新员工{{Name}}")]
    public async Task<bool> UpdateEmployeeAsync(Guid id, EmployeeCreateOrUpdateInput input)
    {
        var entity = await employeeRepository.Where(x => x.Id == id).FirstAsync() ?? throw new EntityNotFoundException(typeof(Employee), id);
        if (entity.Code.ToLower() != input.Code.ToLower() && await employeeRepository.Select.AnyAsync(x => x.Code.ToLower() == input.Code.ToLower()))
        {
            throw HttpFriendlyException.BadRequest($"工号{input.Code}已存在");
        }
        if (!string.IsNullOrEmpty(input.IdNo) && !StringUtils.IgnoreCaseEquals(entity.IdNo, input.IdNo)
            && await employeeRepository.Select.AnyAsync(x => input.IdNo.Equals(x.IdNo, StringComparison.OrdinalIgnoreCase)))
        {
            throw HttpFriendlyException.BadRequest($"身份证号{input.IdNo}已存在");
        }

        ObjectMapper.Map(input, entity);
        await employeeRepository.UpdateAsync(entity);
        BusinessLogManager.Current?.AddVariable("Name", entity.Name);
        BusinessLogManager.Current?.AddEntityId(id);

        return true;
    }


    public async Task<EmployeeInfoDto> GetEmployeeInfoAsync(Guid id)
    {
        var employee = await employeeRepository.Where(x => x.Id == id).FirstAsync() ?? throw new EntityNotFoundException();
        var result = ObjectMapper.Map<Employee, EmployeeInfoDto>(employee);

        // 从User表反向查找关联的用户信息
        var user = await _userRepository.Where(x => x.EmployeeId == id).FirstAsync();
        if (user != null)
        {
            result.UserName = user.UserName;
            result.NickName = user.NickName;
        }

        return result;
    }

    public async Task<List<DeptEmployeeTreeOutput>> GetDeptEmployeeTreeAsync(DeptEmployeeTreeInput dto)
    {
        if (!string.IsNullOrEmpty(dto.EmployeeName))
        {
            return await employeeRepository.Where(x => x.Status == 1 && x.Name.Contains(dto.EmployeeName))
                .ToListAsync(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 2
                });
        }

        var depts = await _deptRepository.Where(x => x.Status == 1).ToListAsync();
        var users = await _userRepository.Select
            .From<Employee>((u, e) => u.LeftJoin(u1 => u1.EmployeeId == e.Id))
            .Where((u, e) => u.DepartmentId != null && e.Status == 1)
            .ToListAsync((u, e) => new { User = u, Employee = e });

        var list = depts.Where(x => !x.ParentId.HasValue).OrderBy(x => x.Sort).Select(x => new DeptEmployeeTreeOutput
        {
            Label = x.Name,
            Value = x.Id.ToString(),
            Type = 1
        }).ToList();

        foreach (var item in list)
        {
            item.Children = GetSubItems(item);
        }

        List<DeptEmployeeTreeOutput>? GetSubItems(DeptEmployeeTreeOutput parent)
        {
            var children = depts.Where(x => x.ParentId.HasValue && x.ParentId.ToString() == parent.Value)
                .OrderBy(x => x.Sort).Select(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 1
                }).ToList();

            foreach (var item in children)
            {
                item.Children = GetSubItems(item);
            }

            // 获取该部门下的员工（通过User表的DeptId关联）
            var subItemEmployees = users.Where(x => x.User.DepartmentId.ToString() == parent.Value)
                .Select(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Employee.Name,
                    Value = x.Employee.Id.ToString(),
                    Type = 2
                }).ToList();

            children.AddRange(subItemEmployees);

            return children.Count > 0 ? children : null;
        }

        return list;
    }

    public async Task<List<EmployeeSelectOption>> GetEmployeeOptionsAsync(string? keyword)
    {
        return await employeeRepository.Select
            .Where(x => x.Status == 1) // 只获取在职员工
            .WhereIf(!string.IsNullOrWhiteSpace(keyword), x => x.Name.Contains(keyword!) || x.Code.Contains(keyword!))
            .OrderBy(x => x.Code)
            .Take(50) // 限制返回数量，避免数据过多
            .ToListAsync(x => new EmployeeSelectOption
            {
                Label = x.Name,
                Value = x.Id.ToString(),
                Code = x.Code
            });
    }

    public async Task<List<EmployeeSelectOption>> GetEmployeesByUserIdsAsync(List<Guid> userIds)
    {
        if (userIds == null || !userIds.Any())
        {
            return [];
        }

        // 根据userIds通过User表的EmployeeId关联到Employee表
        return await _userRepository.Select
            .From<Employee>((u, e) => u.LeftJoin(u1 => u1.EmployeeId == e.Id))
            .Where((u, e) => userIds.Contains(u.Id) && e.Status == 1)
            .OrderBy((u, e) => e.Code)
            .ToListAsync((u, e) => new EmployeeSelectOption
            {
                Label = e.Name,
                Value = e.Id.ToString(),
                Code = e.Code
            });
    }
}