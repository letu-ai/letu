using Letu.Basis.Admin.Departments.Dtos;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Users;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Logging.BusinessLogs;
using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.Departments
{
    public class DepartmentAppService : BasisAppService, IDepartmentAppService
    {
        private readonly IFreeSqlRepository<Department> _deptRepository;
        private readonly IFreeSqlRepository<Employee> _employeeRepository;
        private readonly IFreeSqlRepository<User> _userRepository;

        public DepartmentAppService(IFreeSqlRepository<Department> deptRepository, IFreeSqlRepository<Employee> employeeRepository, IFreeSqlRepository<User> userRepository)
        {
            _deptRepository = deptRepository;
            _employeeRepository = employeeRepository;
            _userRepository = userRepository;
        }

        [BusinessLog("部门管理", BusinessOperateType.Create, "创建部门{{Name}}")]
        public async Task<bool> AddDeptAsync(DepartmentCreateOrUpdateInput dto)
        {
            if (await _deptRepository.Where(x => x.Code.ToLower() == dto.Code!.ToLower()).AnyAsync())
            {
                throw HttpFriendlyException.BadRequest($"部门编号{dto.Code}已存在");
            }

            var entity = ObjectMapper.Map<DepartmentCreateOrUpdateInput, Department>(dto);
            entity.ParentId = dto.ParentId;
            entity.Code = dto.Code;
            if (entity.ParentId.HasValue)
            {
                var all = await _deptRepository.Select.ToListAsync();
                int layer = 1;
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value, ref layer);
                entity.Layer = layer;
            }
            entity = await _deptRepository.InsertAsync(entity);
            BusinessLogManager.Current?.AddVariable("Name", entity.Name);
            BusinessLogManager.Current?.AddVariable("EntityId", entity.Id);

            return true;
        }

        public string GetParentIds(List<Department> all, Guid id, ref int layer)
        {
            layer += 1;
            var parentId = all.Find(x => x.Id == id)?.ParentId;
            if (parentId == null) return id.ToString();
            return GetParentIds(all, parentId.Value, ref layer) + "," + id;
        }


        [BusinessLog("部门管理", BusinessOperateType.Delete, "删除部门")]
        public async Task<bool> DeleteDeptAsync(Guid id)
        {
            var hasUsers = await _userRepository.Select.AnyAsync(x => x.DepartmentId == id);
            if (hasUsers)
                throw HttpFriendlyException.BadRequest("部门内有用户，不能删除。");
            BusinessLogManager.Current?.AddVariable("EntityId", id);

            await _deptRepository.DeleteAsync(x => id == x.Id);
            return true;
        }

        public async Task<List<DepartmentListOutput>> GetDeptListAsync(DeptQueryDto dto)
        {
            bool hasFilter = !string.IsNullOrEmpty(dto.Name) || !string.IsNullOrEmpty(dto.Code)
                || dto.Status > 0;
            if (hasFilter)
            {
                var filter = await _deptRepository
                    .WhereIf(!string.IsNullOrEmpty(dto.Name), x => x.Name.Contains(dto.Name!))
                    .WhereIf(!string.IsNullOrEmpty(dto.Code), x => x.Code.Contains(dto.Code!)) // ==
                    .WhereIf(dto.Status > 0, x => x.Status == dto.Status) // ==
                    .OrderBy(x => x.Sort).ToListAsync();
                var result = ObjectMapper.Map<List<Department>, List<DepartmentListOutput>>(filter);

                // Add curator names for filtered results
                await AddCuratorNames(result); // ++

                return result;
            }
            var all = await _deptRepository.Select.OrderBy(x => x.ParentIds).ToListAsync();
            var tree = ObjectMapper.Map<List<Department>, List<DepartmentListOutput>>(all.Where(x => x.ParentId == null).OrderBy(t => t.Sort).ToList());

            // Add curator names for all departments
            await AddCuratorNames(tree); // ++

            foreach (var item in tree)
            {
                item.Children = getChildren(item.Id)?.OrderBy(x => x.Sort).ToList();
            }

            List<DepartmentListOutput>? getChildren(Guid id)
            {
                var children = ObjectMapper.Map<List<Department>, List<DepartmentListOutput>>(all.Where(x => x.ParentId == id).ToList());
                if (children.Count <= 0) return null;

                // Add curator names for child departments
                AddCuratorNames(children).Wait(); // ++

                foreach (var item in children)
                {
                    item.Children = getChildren(item.Id);
                }

                return children;
            }

            return tree;
        }

        private async Task AddCuratorNames(List<DepartmentListOutput> depts)
        {
            var curatorIds = depts.Select(d => d.CuratorId).Where(id => id.HasValue).Distinct().ToList();

            if (curatorIds.Any())
            {
                var employees = await _employeeRepository
                    .Where(e => curatorIds.Contains(e.Id))
                    .ToListAsync(e => new { e.Id, e.Name });

                var employeeDict = employees.ToDictionary(e => e.Id, e => e.Name);

                foreach (var dept in depts)
                {
                    if (dept.CuratorId.HasValue && employeeDict.TryGetValue(dept.CuratorId.Value, out var name))
                    {
                        dept.CuratorName = name;
                    }
                }
            }
        }

        [BusinessLog("部门管理", BusinessOperateType.Update, "更新部门{{Name}}")]
        public async Task<bool> UpdateDeptAsync(Guid id, DepartmentCreateOrUpdateInput input)
        {
            var entity = await _deptRepository.Where(x => x.Id == id).FirstAsync();
            if (entity == null)
            {
                throw new EntityNotFoundException(typeof(Department), id);
            }

            if (!entity.Code.Equals(input.Code, StringComparison.CurrentCultureIgnoreCase) && await _deptRepository.Select.AnyAsync(x => x.Code.ToLower() == input.Code!.ToLower()))
            {
                throw HttpFriendlyException.BadRequest($"部门编号{input.Code}已存在");
            }
            if (input.ParentId == entity.Id)
            {
                throw HttpFriendlyException.BadRequest("不能选择自己为上级部门");
            }

            ObjectMapper.Map(input, entity);
            if (entity.ParentId.HasValue)
            {
                var parentIsSub = await _deptRepository.Where(x => x.Id == entity.ParentId.Value && x.ParentId == entity.Id).AnyAsync();
                if (parentIsSub)
                {
                    throw HttpFriendlyException.BadRequest("不能选择子部门作为上级部门");
                }

                var all = await _deptRepository.Select.ToListAsync();
                int layer = 1;
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value, ref layer);
                entity.Layer = layer;
            }
            await _deptRepository.UpdateAsync(entity);
            BusinessLogManager.Current?.AddVariable("Name", entity.Name);
            BusinessLogManager.Current?.AddVariable("EntityId", id);

            return true;
        }

        public async Task<List<TreeSelectOption>> GetDeptTreeOptionsAsync()
        {
            var all = await _deptRepository.Select
                .Where(x => x.Status == 1) // 只获取启用的部门
                .OrderBy(x => x.ParentIds)
                .ToListAsync();

            var rootDepts = all.Where(x => x.ParentId == null).OrderBy(x => x.Sort).ToList();
            var result = new List<TreeSelectOption>();

            foreach (var dept in rootDepts)
            {
                result.Add(ConvertToTreeSelectOption(dept, all));
            }

            return result;
        }

        private TreeSelectOption ConvertToTreeSelectOption(Department dept, List<Department> allDepts)
        {
            var option = new TreeSelectOption
            {
                Key = dept.Id.ToString(),
                Value = dept.Id.ToString(),
                Title = dept.Name
            };

            var children = allDepts.Where(x => x.ParentId == dept.Id).OrderBy(x => x.Sort).ToList();
            if (children.Any())
            {
                option.Children = children.Select(child => ConvertToTreeSelectOption(child, allDepts)).ToList();
            }

            return option;
        }
    }
}