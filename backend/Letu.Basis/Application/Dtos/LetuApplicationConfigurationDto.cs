using Letu.Basis.Admin.Menus.Dtos;
using Volo.Abp.AspNetCore.Mvc.ApplicationConfigurations;

namespace Letu.Basis.Application.Dtos;

[Serializable]
public class LetuApplicationConfigurationDto : ApplicationConfigurationDto
{
    public LetuApplicationConfigurationDto()
    {
        Menu = [];
    }

    public List<NavigationMenuDto> Menu { get; set; }
}
