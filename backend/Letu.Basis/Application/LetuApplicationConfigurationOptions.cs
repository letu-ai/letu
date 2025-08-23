using System.ComponentModel.DataAnnotations;
using Volo.Abp.AspNetCore.Mvc.ApplicationConfigurations;

namespace Letu.Basis.Application;

public class LetuApplicationConfigurationRequestOptions : ApplicationConfigurationRequestOptions
{
    /// <summary>
    /// 这个名称决定返回的菜单种类。
    /// 目前种类有app和admin两类
    /// </summary>
    [StringLength(32)]
    public string? ApplicationName { get; set; }
}