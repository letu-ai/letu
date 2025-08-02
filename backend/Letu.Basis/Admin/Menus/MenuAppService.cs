using FreeSql;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Core.Utils;
using Letu.Repository;
using Letu.Shared.Enums;
using Volo.Abp;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Menus
{
    public class MenuAppService : ApplicationService, IMenuAppService
    {
        private readonly IFreeSqlRepository<MenuItem> _menuRepository;

        public MenuAppService(IFreeSqlRepository<MenuItem> menuRepository)
        {
            _menuRepository = menuRepository;
        }

        public async Task AddMenuAsync(MenuCreateOrUpdateInput dto)
        {
            if (dto.MenuType == (int)MenuType.Menu && string.IsNullOrWhiteSpace(dto.Path))
            {
                throw new BusinessException(message: "菜单的路由不能为空");
            }
            if (dto.IsExternal && !StringUtils.IsValidUrlStrict(dto.Path))
            {
                throw new BusinessException(message: "外链地址不合法");
            }
            if (dto.ParentId.HasValue)
            {
                var parentMenu = await _menuRepository.Where(x => x.Id == dto.ParentId).FirstAsync();
                if (parentMenu.MenuType == MenuType.Button)
                {
                    throw new BusinessException(message: "菜单父级不能是按钮");
                }
            }
            var isExist = await _menuRepository.Select.AnyAsync(x => x.Path != null && dto.Path != null && x.Path.ToLower() == dto.Path.ToLower());
            if (isExist)
            {
                throw new BusinessException(message: $"已存在【{dto.Path}】菜单路由");
            }
            var entity = ObjectMapper.Map<MenuCreateOrUpdateInput, MenuItem>(dto);
            await _menuRepository.InsertAsync(entity);
        }

        public async Task DeleteMenusAsync(Guid[] ids)
        {
            await _menuRepository.DeleteAsync(x => ids.Contains(x.Id));
        }

        public async Task<List<MenuListOutput>> GetMenuListAsync(MenuQueryDto dto)
        {
            //是否过滤
            var isFilter = !string.IsNullOrEmpty(dto.Title) || !string.IsNullOrEmpty(dto.Path);
            var all = await _menuRepository
                .WhereIf(!string.IsNullOrEmpty(dto.Title), x => !string.IsNullOrEmpty(x.Title) && x.Title.Contains(dto.Title!))
                .WhereIf(!string.IsNullOrEmpty(dto.Path), x => !string.IsNullOrEmpty(x.Path) && x.Path.Contains(dto.Path!))
                .ToListAsync();
            var top = all.Where(x => isFilter || !x.ParentId.HasValue || x.ParentId == Guid.Empty).OrderBy(x => x.Sort).ToList();
            var topMap = ObjectMapper.Map<List<MenuItem>, List<MenuListOutput>>(top);
            if (isFilter) return topMap;
            foreach (var item in topMap)
            {
                item.Children = getChildren(item.Id);
            }

            List<MenuListOutput>? getChildren(Guid currentId)
            {
                var children = all.Where(x => x.ParentId == currentId).OrderBy(x => x.Sort).ToList();
                if (children.Count == 0) return null;
                var childrenMap = ObjectMapper.Map<List<MenuItem>, List<MenuListOutput>>(children);
                foreach (var item in childrenMap)
                {
                    item.Children = getChildren(item.Id);
                }
                return childrenMap;
            }

            return topMap;
        }

        public async Task<(string[] keys, List<MenuOptionTreeDto> tree)> GetMenuOptionsAsync(bool onlyMenu, string? keyword)
        {
            var isKeywordSearch = !string.IsNullOrEmpty(keyword);
            var all = await _menuRepository.WhereIf(onlyMenu, x => x.MenuType == MenuType.Folder || x.MenuType == MenuType.Menu)
                .WhereIf(isKeywordSearch, x => x.Title != null && x.Title.Contains(keyword!)).ToListAsync();
            var keys = all.Select(x => x.Id.ToString()).ToArray();

            if (isKeywordSearch)
            {
                var list = all.Select(x => new MenuOptionTreeDto() { Key = x.Id.ToString(), Title = x.Title, MenuType = (int)x.MenuType }).ToList();
                return (keys, list);
            }

            var top = all.Where(x => !x.ParentId.HasValue || x.ParentId == Guid.Empty && x.MenuType == MenuType.Menu)
                .OrderBy(x => x.Sort).ToList();
            var topMap = new List<MenuOptionTreeDto>();
            foreach (var item in top)
            {
                topMap.Add(new MenuOptionTreeDto
                {
                    Key = item.Id.ToString(),
                    Title = item.Title,
                    Children = getChildren(item.Id),
                    MenuType = (int)item.MenuType
                });
            }

            List<MenuOptionTreeDto>? getChildren(Guid currentId)
            {
                var children = all.Where(x => x.ParentId == currentId).OrderBy(x => x.Sort).ToList();
                if (children.Count == 0) return null;
                var childrenMap = new List<MenuOptionTreeDto>();
                foreach (var item in children)
                {
                    childrenMap.Add(new MenuOptionTreeDto
                    {
                        Key = item.Id.ToString(),
                        Title = item.Title,
                        Children = getChildren(item.Id),
                        MenuType = (int)item.MenuType
                    });
                }
                return childrenMap;
            }

            return (keys, topMap);
        }

        public async Task UpdateMenuAsync(Guid id, MenuCreateOrUpdateInput input)
        {
            if (input.MenuType == (int)MenuType.Menu && string.IsNullOrWhiteSpace(input.Path))
            {
                throw new BusinessException(message: "菜单的路由不能为空");
            }
            if (input.IsExternal && !StringUtils.IsValidUrlStrict(input.Path))
            {
                throw new BusinessException(message: "外链地址不合法");
            }
            if (input.ParentId.HasValue)
            {
                var parentMenu = await _menuRepository.Where(x => x.ParentId == input.ParentId).FirstAsync();
                if (parentMenu.MenuType == MenuType.Button)
                {
                    throw new BusinessException(message: "菜单父级不能是按钮");
                }
            }
            var isExist = await _menuRepository.Select.AnyAsync(x => x.Path != null && input.Path != null && x.Path.ToLower() == input.Path.ToLower());
            var entity = await _menuRepository.Where(x => x.Id == id).FirstAsync() ?? throw new BusinessException(message: "数据不存在");
            if (isExist && entity.Path != null && input.Path!.ToLower() != entity.Path.ToLower())
            {
                throw new BusinessException(message: $"已存在【{input.Path}】菜单路由");
            }
            if (input.ParentId == entity.Id)
            {
                throw new BusinessException(message: "不能选择自己为父级");
            }

            bool updatePermission = input.Permission != entity.Permission;

            entity.Title = input.Title;
            entity.Icon = input.Icon;
            entity.Path = input.Path;
            entity.MenuType = (MenuType)input.MenuType;
            entity.Permission = input.Permission;
            entity.ParentId = input.ParentId;
            entity.Sort = input.Sort;
            entity.Display = input.Display;
            entity.Component = input.Component;
            entity.IsExternal = input.IsExternal;
            await _menuRepository.UpdateAsync(entity);
        }
    }
}