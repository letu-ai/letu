using Letu.Core.Helpers;
using Letu.Repository;
using FreeSql;
using System.Data;
using Letu.Basis.Admin.Employees;
using Letu.Basis.Admin.Positions.Dtos;

namespace Letu.Basis.Admin.Positions
{
    public class PositionAppService : IPositionAppService
    {
        private readonly IRepository<Position> _positionRepository;
        private readonly IRepository<PositionGroup> _positionGroupRepository;
        private readonly IRepository<Employee> _employeeRepository;

        public PositionAppService(IRepository<Position> positionRepository, IRepository<PositionGroup> positionGroupRepository
            , IRepository<Employee> employeeRepository)
        {
            _positionRepository = positionRepository;
            _positionGroupRepository = positionGroupRepository;
            _employeeRepository = employeeRepository;
        }

        public async Task<bool> AddPositionGroupAsync(PositionGroupDto dto)
        {
            var entity = AutoMapperHelper.Instance.Map<PositionGroupDto, PositionGroup>(dto);
            entity.ParentId = dto.ParentId;
            if (entity.ParentId.HasValue)
            {
                var all = await _positionGroupRepository.Select.ToListAsync();
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value);
            }
            await _positionGroupRepository.InsertAsync(entity);
            return true;
        }

        public string GetParentIds(List<PositionGroup> all, Guid id)
        {
            var parentId = all.Find(x => x.Id == id)?.ParentId;
            if (parentId == null) return id.ToString();
            return GetParentIds(all, parentId.Value) + "," + id;
        }

        public async Task<bool> DeletePositionGroupAsync(Guid id)
        {
            var hasPositions = await _positionRepository.Select.AnyAsync(x => x.GroupId == id);
            if (hasPositions)
            {
                throw new BusinessException(message: "分组下有职位，不能删除");
            }
            await _positionGroupRepository.DeleteAsync(x => x.Id == id);
            return true;
        }

        public async Task<List<PositionGroupListDto>> GetPositionGroupListAsync(PositionGroupQueryDto dto)
        {
            var rawTree = await _positionGroupRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.GroupName), x => x.GroupName.Contains(dto.GroupName!))
                .OrderBy(x => x.Sort)
                .ToTreeListAsync();

            return AutoMapperHelper.Instance.Map<List<PositionGroup>, List<PositionGroupListDto>>(rawTree);
        }

        public async Task<bool> UpdatePositionGroupAsync(PositionGroupDto dto)
        {
            if (!dto.Id.HasValue) throw new ArgumentNullException(nameof(dto.Id));
            var entity = await _positionGroupRepository.Where(x => x.Id == dto.Id).FirstAsync();
            if (dto.ParentId == entity.Id)
            {
                throw new BusinessException(message: "不能选择自己为父级");
            }

            entity.GroupName = dto.GroupName;
            entity.Remark = dto.Remark;
            entity.ParentId = dto.ParentId;
            entity.Sort = dto.Sort;
            if (entity.ParentId.HasValue)
            {
                var all = await _positionGroupRepository.Select.ToListAsync();
                entity.ParentIds = GetParentIds(all, entity.ParentId.Value);
            }
            await _positionGroupRepository.UpdateAsync(entity);
            return true;
        }

        private async Task<List<PosistionLayerNames>> GetPosistionGroupNameAsync(List<Guid> ids)
        {
            var positions = await _positionRepository.Where(x => ids.Contains(x.Id)).ToListAsync(x => new { x.Id, x.GroupId });
            var groups = await _positionGroupRepository.Select.ToListAsync();
            var list = new List<PosistionLayerNames>();

            foreach (var item in positions)
            {
                var single = new PosistionLayerNames
                {
                    Id = item.Id
                };
                var allGroups = groups.Where(x => x.Id == item.GroupId).Select(x => x.ParentIds + "," + x.Id);
                foreach (var groupIds in allGroups)
                {
                    foreach (var groupId in groupIds.Split(","))
                    {
                        single.LayerName += groups.Find(x => x.Id.ToString() == groupId)?.GroupName + "/";
                    }
                }
                single.LayerName = single.LayerName?.Trim('/');

                list.Add(single);
            }

            return list;
        }

        public async Task<bool> AddPositionAsync(PositionDto dto)
        {
            if (_positionRepository.Select.Any(x => x.Code.ToLower() == dto.Code!.ToLower()))
            {
                throw new BusinessException(message: "职位编号已存在");
            }
            var entity = AutoMapperHelper.Instance.Map<PositionDto, Position>(dto);
            await _positionRepository.InsertAsync(entity);
            return true;
        }

        public async Task<bool> DeletePositionAsync(Guid id)
        {
            var hasEmployees = await _employeeRepository.Select.AnyAsync(x => x.PositionId == id);
            if (hasEmployees) throw new BusinessException(message: "职位正在使用，不能删除");
            await _positionRepository.DeleteAsync(x => x.Id == id);
            return true;
        }

        public async Task<PagedResult<PositionListDto>> GetPositionListAsync(PositionQueryDto dto)
        {
            var rows = await _positionRepository.Select
                .WhereIf(!string.IsNullOrEmpty(dto.Keyword), x => x.Name.Contains(dto.Keyword!) || x.Code.Contains(dto.Keyword!))
                .WhereIf(dto.Level > 0, x => x.Level == dto.Level)
                .WhereIf(dto.Status > 0, x => x.Status == dto.Status)
                .WhereIf(dto.GroupId.HasValue, x => x.GroupId == dto.GroupId)
                .OrderBy(x => x.Level)
                .OrderBy(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync();
            var ids = rows.Select(x => x.Id).ToList();
            var list = AutoMapperHelper.Instance.Map<List<Position>, List<PositionListDto>>(rows);
            var names = await GetPosistionGroupNameAsync(ids);
            foreach (var item in list)
            {
                var tmp = names.FirstOrDefault(x => x.Id == item.Id);
                item.LayerName = tmp?.LayerName;
            }
            return new PagedResult<PositionListDto>(total, list);
        }

        public async Task<bool> UpdatePositionAsync(PositionDto dto)
        {
            if (!dto.Id.HasValue) throw new ArgumentNullException(nameof(dto.Id));
            var entity = await _positionRepository.Where(x => x.Id == dto.Id).FirstAsync()
                ?? throw new BusinessException(message: "数据不存在");
            string code = dto.Code!.ToLower();
            if (entity.Code.ToLower() != code && _positionRepository.Select.Any(x => x.Code.ToLower() == code))
            {
                throw new BusinessException(message: "职位编号已存在");
            }

            entity.Name = dto.Name;
            entity.Code = dto.Code;
            entity.Level = dto.Level;
            entity.Status = dto.Status;
            entity.Description = dto.Description;
            entity.GroupId = dto.GroupId;
            await _positionRepository.UpdateAsync(entity);
            return true;
        }

        public async Task<List<AppOptionTree>> GetPositionTreeOptionAsync()
        {
            var groups = await _positionGroupRepository.Select.ToListAsync();
            var positions = await _positionRepository.Select.ToListAsync();
            var topGroups = groups.Where(x => !x.ParentId.HasValue).ToList();
            var list = new List<AppOptionTree>();
            List<AppOptionTree> GetChildren(string id)
            {
                var items = groups.Where(x => x.ParentId.ToString() == id);
                var children = new List<AppOptionTree>();
                if (items.Any())
                {
                    foreach (var item in items)
                    {
                        var t = new AppOptionTree()
                        {
                            Label = item.GroupName,
                            Value = item.Id.ToString()
                        };
                        t.Children = GetChildren(t.Value);
                        children.Add(t);
                        //最底级查职位
                        if (t.Children.Count == 0)
                        {
                            t.Children = positions.Where(x => x.GroupId.ToString() == t.Value).Select(x => new AppOptionTree
                            {
                                Label = x.Name,
                                Value = x.Id.ToString()
                            }).ToList();
                        }
                    }
                }
                else
                {
                    children = positions.Where(x => x.GroupId.ToString() == id).Select(x => new AppOptionTree
                    {
                        Label = x.Name,
                        Value = x.Id.ToString()
                    }).ToList();
                }
                return children;
            }

            foreach (var group in topGroups)
            {
                var t = new AppOptionTree()
                {
                    Label = group.GroupName,
                    Value = group.Id.ToString()
                };
                t.Children = GetChildren(t.Value);
                list.Add(t);
            }
            return list;
        }
    }
}