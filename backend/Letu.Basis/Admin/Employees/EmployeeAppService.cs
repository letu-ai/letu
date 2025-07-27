using AutoMapper;
using Letu.Basis.Admin.Departments;
using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees.Dtos;
using Letu.Basis.Admin.Positions;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Users.Dtos;
using Letu.Basis.IService.System.Dtos;
using Letu.Core.Interfaces;
using Letu.Core.Utils;
using Letu.Repository;
using Letu.Repository.Aop;

namespace Letu.Basis.Admin.Employees
{
    public class EmployeeAppService : IScopedDependency, IEmployeeAppService
    {
        private readonly IRepository<Employee> _employeeRepository;
        private readonly IRepository<Department> _deptRepository;
        private readonly IFreeSql _freeSql;
        private readonly IMapper _mapper;
        private readonly IUserAppService _userService;
        private readonly IRepository<User> _userRepository;

        public EmployeeAppService(IRepository<Employee> employeeRepository, IRepository<Department> deptRepository, IRepository<Position> orgPositionRepository
            , IFreeSql freeSql, IMapper mapper, IUserAppService userService, IRepository<User> userRepository)
        {
            _employeeRepository = employeeRepository;
            _deptRepository = deptRepository;
            _freeSql = freeSql;
            _mapper = mapper;
            _userService = userService;
            _userRepository = userRepository;
        }

        [AsyncTransactional]
        public async Task<bool> AddEmployeeAsync(EmployeeDto dto)
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
                userId = await _userService.AddUserAsync(new UserDto
                {
                    NickName = dto.Name,
                    Sex = dto.Sex,
                    Phone = dto.Phone,
                    UserName = dto.Phone,
                    Password = dto.UserPassword
                });
            }

            var entity = _mapper.Map<EmployeeDto, Employee>(dto);
            entity.UserId = userId;
            await _employeeRepository.InsertAsync(entity);

            return true;
        }

        public async Task<bool> DeleteEmployeeAsync(Guid id)
        {
            await _employeeRepository.DeleteAsync(x => x.Id == id);
            return true;
        }

        public async Task<PagedResult<EmployeeListDto>> GetEmployeePagedListAsync(EmployeeQueryDto dto)
        {
            var list = await _freeSql.Select<Employee>().From<Department, Position>((e, d, p) => e.LeftJoin(e1 => e1.DeptId == d.Id).LeftJoin(e2 => e2.PositionId == p.Id))
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), (x, d, p) => x.Code!.Contains(dto.Keyword!) || x.Name!.Contains(dto.Keyword!) || x.Phone!.Contains(dto.Keyword!))
                .WhereIf(dto.DeptId.HasValue, (x, d, p) => x.DeptId == dto.DeptId!.Value)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync((e, d, p) => new EmployeeListDto
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

            return new PagedResult<EmployeeListDto>(dto) { Items = list, TotalCount = total };
        }

        public async Task<List<EmployeeDto>> GetEmployeeListAsync(EmployeeQueryDto dto)
        {
            return await _employeeRepository.Where(x => x.Status == 1)
                .WhereIf(dto.DeptId != null, x => x.DeptId == dto.DeptId!.Value)
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name!.Contains(dto.Keyword!))
                .ToListAsync<EmployeeDto>();
        }

        public async Task<bool> UpdateEmployeeAsync(EmployeeDto dto)
        {
            ArgumentNullException.ThrowIfNull(dto.Id);
            var entity = await _employeeRepository.Where(x => x.Id == dto.Id.Value).FirstAsync();
            if (entity.Code.ToLower() != dto.Code.ToLower() && await _employeeRepository.Select.AnyAsync(x => x.Code.ToLower() == dto.Code.ToLower()))
            {
                throw new BusinessException(message: "工号已存在");
            }
            if (entity.Phone != dto.Phone && await _employeeRepository.Select.AnyAsync(x => x.Phone == dto.Phone))
            {
                throw new BusinessException(message: "手机号已存在");
            }
            if (!string.IsNullOrEmpty(dto.Email) && !StringUtils.IgnoreCaseEquals(entity.Email, dto.Email)
                && await _employeeRepository.Select.AnyAsync(x => dto.Email.Equals(x.Email, StringComparison.OrdinalIgnoreCase)))
            {
                throw new BusinessException(message: "邮箱已存在");
            }
            if (!string.IsNullOrEmpty(dto.IdNo) && !StringUtils.IgnoreCaseEquals(entity.IdNo, dto.IdNo)
                && await _employeeRepository.Select.AnyAsync(x => dto.IdNo.Equals(x.IdNo, StringComparison.OrdinalIgnoreCase)))
            {
                throw new BusinessException(message: "身份证号已存在");
            }

            ReflectionUtils.CopyTo(dto, entity, "Id");
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
            var result = _mapper.Map<EmployeeInfoDto>(employee);

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

        public async Task<List<DeptEmployeeTreeDto>> GetDeptEmployeeTreeAsync(DeptEmployeeTreeQueryDto dto)
        {
            if (!string.IsNullOrEmpty(dto.EmployeeName))
            {
                return await _employeeRepository.Where(x => x.Status == 1).ToListAsync(x => new DeptEmployeeTreeDto
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 2
                });
            }
            var employees = await _employeeRepository.Where(x => x.Status == 1).ToListAsync();
            var depts = await _deptRepository.Where(x => x.Status == 1).ToListAsync();
            var list = depts.Where(x => !x.ParentId.HasValue).OrderBy(x => x.Sort).Select(x => new DeptEmployeeTreeDto
            {
                Label = x.Name,
                Value = x.Id.ToString(),
                Type = 1
            }).ToList();
            foreach (var item in list)
            {
                item.Children = GetSubItems(item);
            }

            List<DeptEmployeeTreeDto>? GetSubItems(DeptEmployeeTreeDto parent)
            {
                var children = depts.Where(x => x.ParentId.HasValue && x.ParentId.ToString() == parent.Value).OrderBy(x => x.Sort).Select(x => new DeptEmployeeTreeDto
                {
                    Label = x.Name,
                    Value = x.Id.ToString(),
                    Type = 1
                }).ToList();
                foreach (var item in children)
                {
                    item.Children = GetSubItems(item);
                }

                var subItemEmployees = employees.Where(x => x.DeptId.ToString() == parent.Value).Select(x => new DeptEmployeeTreeDto
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