using Fancyx.Admin.Entities.Organization;
using Fancyx.Admin.IService.Organization;
using Fancyx.Admin.IService.Organization.Dtos;
using Fancyx.Core.Helpers;
using Fancyx.Repository;

namespace Fancyx.Admin.Service.Organization
{
    public class DeptService : IDeptService
    {
        private readonly IRepository<DeptDO> _deptRepository;
        private readonly IRepository<EmployeeDO> _employeeRepository;

        public DeptService(IRepository<DeptDO> deptRepository, IRepository<EmployeeDO> employeeRepository)
        {
            _deptRepository = deptRepository;
            _employeeRepository = employeeRepository;
        }

        public async Task<bool> AddDeptAsync(DeptDto dto)
        {
            if (await _deptRepository.Where(x => x.Code.ToLower() == dto.Code!.ToLower()).AnyAsync())
            {
                throw new BusinessException(message: "部门编号已存在");
            }

            var entity = AutoMapperHelper.Instance.Map<DeptDto, DeptDO>(dto);
            entity.ParentId = dto.ParentId;
            entity.Code = dto.Code;
            if (entity.ParentId.HasValue)
            {
                var all = await _deptRepository.Select.ToListAsync();
                int layer = 1;
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value, ref layer);
                entity.Layer = layer;
            }
            await _deptRepository.InsertAsync(entity);
            return true;
        }

        public string GetParentIds(List<DeptDO> all, Guid id, ref int layer)
        {
            layer += 1;
            var parentId = all.Find(x => x.Id == id)?.ParentId;
            if (parentId == null) return id.ToString();
            return GetParentIds(all, parentId.Value, ref layer) + "," + id;
        }

        public async Task<bool> DeleteDeptAsync(Guid id)
        {
            var hasEmployees = await _employeeRepository.Select.AnyAsync(x => x.DeptId == id);
            if (hasEmployees) throw new BusinessException(message: "部门下存在员工，不能删除");
            await _deptRepository.DeleteAsync(x => id == x.Id);
            return true;
        }

        public async Task<List<DeptListDto>> GetDeptListAsync(DeptQueryDto dto)
        {
            bool hasFilter = !string.IsNullOrEmpty(dto.Name) || !string.IsNullOrEmpty(dto.Code)
                || dto.Status > 0;
            if (hasFilter)
            {
                var filter = await _deptRepository
                    .WhereIf(!string.IsNullOrEmpty(dto.Name), x => x.Name.Contains(dto.Name!))
                    .WhereIf(!string.IsNullOrEmpty(dto.Code), x => x.Name.Contains(dto.Code!))
                    .WhereIf(dto.Status > 0, x => x.Status > 0)
                    .OrderBy(x => x.Sort).ToListAsync();
                return AutoMapperHelper.Instance.Map<List<DeptDO>, List<DeptListDto>>(filter);
            }
            var all = await _deptRepository.Select.OrderBy(x => x.ParentIds).ToListAsync();
            var tree = AutoMapperHelper.Instance.Map<List<DeptDO>, List<DeptListDto>>(all.Where(x => x.ParentId == null).OrderBy(t => t.Sort).ToList());
            foreach (var item in tree)
            {
                item.Children = getChildren(item.Id);
            }

            List<DeptListDto>? getChildren(Guid id)
            {
                var children = AutoMapperHelper.Instance.Map<List<DeptDO>, List<DeptListDto>>(all.Where(x => x.ParentId == id).ToList());
                if (children.Count <= 0) return null;

                foreach (var item in children)
                {
                    item.Children = getChildren(item.Id);
                }

                return children;
            }

            return tree;
        }

        public async Task<bool> UpdateDeptAsync(DeptDto dto)
        {
            if (!dto.Id.HasValue) throw new ArgumentNullException(nameof(dto.Id));

            var entity = await _deptRepository.Where(x => x.Id == dto.Id).FirstAsync();
            if (!entity.Code.Equals(dto.Code, StringComparison.CurrentCultureIgnoreCase) && await _deptRepository.Select.AnyAsync(x => x.Code.ToLower() == dto.Code!.ToLower()))
            {
                throw new BusinessException(message: "部门编号已存在");
            }
            if (dto.ParentId == entity.Id)
            {
                throw new BusinessException(message: "不能选择自己为父级");
            }

            entity.Name = dto.Name;
            entity.Code = dto.Code;
            entity.Sort = dto.Sort;
            entity.Description = dto.Description;
            entity.Status = dto.Status;
            entity.CuratorId = dto.CuratorId;
            entity.Email = dto.Email;
            entity.Phone = dto.Phone;
            entity.ParentId = dto.ParentId;
            if (entity.ParentId.HasValue)
            {
                var all = await _deptRepository.Select.ToListAsync();
                int layer = 1;
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value, ref layer);
                entity.Layer = layer;
            }
            await _deptRepository.UpdateAsync(entity);
            return true;
        }
    }
}