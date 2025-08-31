using AutoMapper;
using Letu.Basis.Account.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.Loggings;

namespace Letu.Basis.Account
{
    public class AccountAutoMapperProfile : Profile
    {
        public AccountAutoMapperProfile()
        {
            CreateMap<User, UserInfoUpdateInput>();
            CreateMap<SecurityLog, SecurityLogListDto>()
                .ForMember(dest => dest.Location, opt => opt.MapFrom(src => src.Address))
                .ForMember(dest => dest.Os, opt => opt.MapFrom(src => ExtractOsFromBrowser(src.Browser)))
                .ForMember(dest => dest.Device, opt => opt.MapFrom(src => ExtractDeviceFromBrowser(src.Browser)));
        }
        
        private static string? ExtractOsFromBrowser(string? browser)
        {
            if (string.IsNullOrEmpty(browser))
                return "未知";
                
            if (browser.Contains("Windows"))
                return "Windows";
            else if (browser.Contains("Mac"))
                return "macOS";
            else if (browser.Contains("Linux"))
                return "Linux";
            else if (browser.Contains("Android"))
                return "Android";
            else if (browser.Contains("iOS"))
                return "iOS";
            else
                return "未知";
        }
        
        private static string? ExtractDeviceFromBrowser(string? browser)
        {
            if (string.IsNullOrEmpty(browser))
                return "未知";
                
            if (browser.Contains("Mobile") || browser.Contains("Android") || browser.Contains("iPhone"))
                return "移动设备";
            else if (browser.Contains("Tablet") || browser.Contains("iPad"))
                return "平板设备";
            else
                return "桌面设备";
        }
    }
}
