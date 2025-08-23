using Letu.Core.Applications;

namespace Letu.Basis.Admin.Menus.Dtos
{
    public class MenuTreeSelectOption : TreeSelectOption<MenuTreeSelectOption>
    {
        public int Sort { get; set; }
        public MenuType MenuType { get; set; }
    }
}
