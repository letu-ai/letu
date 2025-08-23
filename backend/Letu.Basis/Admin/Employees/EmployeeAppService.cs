using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Core.Applications;
using Letu.Core.Utils;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Uow;

namespace Letu.Basis.Admin.Employees
{
    public class EmployeeAppService : BasisAppService, IEmployeeAppService
    {
        private readonly IFreeSqlRepository<Employee> _employeeRepository;
        private readonly IFreeSqlRepository<Department> _deptRepository;
        private readonly IUserAppService _userService;
        private readonly IFreeSqlRepository<User> _userRepository;

        public EmployeeAppService(IFreeSqlRepository<Employee> employeeRepository, IFreeSqlRepository<Department> deptRepository, IFreeSqlRepository<Position> orgPositionRepository
            , IUserAppService userService, IFreeSqlRepository<User> userRepository)
        {
            _employeeRepository = employeeRepository;
            _deptRepository = deptRepository;
            _userService = userService;
            _userRepository = userRepository;
        }

        [UnitOfWork]
        public async Task<bool> AddEmployeeAsync(EmployeeCreateOrUpdateInput dto)
        {
            if (await _employeeRepository.Select.AnyAsync(x => x.Code.ToLower() == dto.Code.ToLower()))
            {
                throw new BusinessException(message: "工号已存在");
            }
            if (await _employeeRepository.Select.AnyAsync(x => x.Phone == dto.Phone))
            {
                throw new BusinessException(message: "手机号已存在");
            }
            if (!string.IsNullOrEmpty(dto.Email) && await _employeeRepository.Select.AnyAsync(x => x.Email != null && x.Email.ToLower() == dto.Email.ToLower()))
            {
                throw new BusinessException(message: "邮箱已存在");
            }
            if (!string.IsNullOrEmpty(dto.IdNo) && await _employeeRepository.Select.AnyAsync(x => dto.IdNo.Equals(x.IdNo, StringComparison.OrdinalIgnoreCase)))
            {
                throw new BusinessException(message: "身份证号已存在");
            }

            Guid? userId = null;
            if (dto.IsAddUser)
            {
                if (string.IsNullOrEmpty(dto.UserPassword))
                {
                    throw new BusinessException(message: "用户密码不能为空");
                }
                userId = await _userService.AddUserAsync(new UserCreateOrUpdateInput
                {
                    NickName = dto.Name,
                    Sex = dto.Sex,
                    Phone = dto.Phone,
                    UserName = dto.Phone,
                    Password = dto.UserPassword
                });
            }

            var entity = ObjectMapper.Map<EmployeeCreateOrUpdateInput, Employee>(dto);
            entity.UserId = userId;
            await _employeeRepository.InsertAsync(entity);

            return true;
        }

        public async Task<bool> DeleteEmployeeAsync(Guid id)
        {
            await _employeeRepository.DeleteAsync(x => x.Id == id);
            return true;
        }

        public async Task<PagedResult<EmployeeListOutput>> GetEmployeePagedListAsync(EmployeeListInput dto)
        {
            var list = await _employeeRepository.Select.From<Department, Position>((e, d, p) => e.LeftJoin(e1 => e1.DeptId == d.Id).LeftJoin(e2 => e2.PositionId == p.Id))
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), (x, d, p) => x.Code!.Contains(dto.Keyword!) || x.Name!.Contains(dto.Keyword!) || x.Phone!.Contains(dto.Keyword!))
                .WhereIf(dto.DeptId.HasValue, (x, d, p) => x.DeptId == dto.DeptId!.Value)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync((e, d, p) => new EmployeeListOutput
                {
                    Id = e.Id,
                    Code = e.Code,
                    Name = e.Name,
                    Sex = e.Sex,
                    Phone = e.Phone,
                    IdNo = e.IdNo,
                    FrontIdNoUrl = e.FrontIdNoUrl,
                    BackIdNoUrl = e.BackIdNoUrl,
                    Birthday = e.Birthday,
                    Address = e.Address,
                    Email = e.Email,
                    InTime = e.InTime,
                    OutTime = e.OutTime,
                    Status = e.Status,
                    UserId = e.UserId,
                    DeptId = e.DeptId,
                    PositionId = e.PositionId,
                    DeptName = d.Name,
                    PositionName = p.Name,
                });

            return new PagedResult<EmployeeListOutput>(dto) { Items = list, TotalCount = total };
        }

        public async Task<List<EmployeeCreateOrUpdateInput>> GetEmployeeListAsync(EmployeeListInput dto)
        {
            return await _employeeRepository.Where(x => x.Status == 1)
                .WhereIf(dto.DeptId != null, x => x.DeptId == dto.DeptId!.Value)
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name!.Contains(dto.Keyword!))
                .ToListAsync<EmployeeCreateOrUpdateInput>();
        }

        public async Task<bool> UpdateEmployeeAsync(Guid id, EmployeeCreateOrUpdateInput input)
        {
            var entity = await _employeeRepository.Where(x => x.Id == id).FirstAsync() ?? throw new EntityNotFoundException(typeof(Employee), id);
            if (entity.Code.ToLower() != input.Code.ToLower() && await _employeeRepository.Select.AnyAsync(x => x.Code.ToLower() == input.Code.ToLower()))
            {
                throw new BusinessException(message: "工号已存在");
            }
            if (entity.Phone != input.Phone && await _employeeRepository.Select.AnyAsync(x => x.Phone == input.Phone))
            {
                throw new BusinessException(message: "手机号已存在");
            }
            if (!string.IsNullOrEmpty(input.Email) && !StringUtils.IgnoreCaseEquals(entity.Email, input.Email)
                && await _employeeRepository.Select.AnyAsync(x => input.Email.Equals(x.Email, StringComparison.OrdinalIgnoreCase)))
            {
                throw new BusinessException(message: "邮箱已存在");
            }
            if (!string.IsNullOrEmpty(input.IdNo) && !StringUtils.IgnoreCaseEquals(entity.IdNo, input.IdNo)
                && await _employeeRepository.Select.AnyAsync(x => input.IdNo.Equals(x.IdNo, StringComparison.OrdinalIgnoreCase)))
            {
                throw new BusinessException(message: "身份证号已存在");
            }

            ObjectMapper.Map(input, entity);
            await _employeeRepository.UpdateAsync(entity);
            return true;
        }

        public async Task EmployeeBindUserAsync(EmployeeBindUserDto dto)
        {
            var employee = await _employeeRepository.Where(x => x.Id == dto.EmployeeId).FirstAsync() ?? throw new EntityNotFoundException();
            employee.UserId = dto.UserId;
            await _employeeRepository.UpdateAsync(employee);
        }

        public async Task<EmployeeInfoDto> GetEmployeeInfoAsync(Guid id)
        {
            var employee = await _employeeRepository.Where(x => x.Id == id).FirstAsync() ?? throw new EntityNotFoundException();
            var result = ObjectMapper.Map<Employee, EmployeeInfoDto>(employee);

            if (employee.UserId.HasValue)
            {
                var user = await _userRepository.OneAsync(x => x.Id == employee.UserId.Value);
                if (user != null)
                {
                    result.UserName = user.UserName;
                    result.NickName = user.NickName;
                }
            }

            return result;
        }

        public async Task<List<DeptEmployeeTreeOutput>> GetDeptEmployeeTreeAsync(DeptEmployeeTreeInput dto)
        {
            if (!string.IsNullOrEmpty(dto.EmployeeName))
            {
                return await _employeeRepository.Where(x => x.Status == 1).ToListAsync(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 2
                });
            }
            var employees = await _employeeRepository.Where(x => x.Status == 1).ToListAsync();
            var depts = await _deptRepository.Where(x => x.Status == 1).ToListAsync();
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
                var children = depts.Where(x => x.ParentId.HasValue && x.ParentId.ToString() == parent.Value).OrderBy(x => x.Sort).Select(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 1
                }).ToList();
                foreach (var item in children)
                {
                    item.Children = GetSubItems(item);
                }

                var subItemEmployees = employees.Where(x => x.DeptId.ToString() == parent.Value).Select(x => new DeptEmployeeTreeOutput
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 2
                }).ToList();

                children.AddRange(subItemEmployees);

                return children.Count > 0 ? children : null;
            }

            return list;
        }
    }
}