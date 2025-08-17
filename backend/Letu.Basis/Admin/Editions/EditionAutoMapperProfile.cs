using AutoMapper;
using Letu.Basis.Admin.Editions.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.Editions
{
    public class EditionAutoMapperProfile : Profile
    {
        public EditionAutoMapperProfile()
        {
            CreateMap<EditionCreateOrUpdateInput, Edition>(MemberList.Source)
                .Ignore(dest => dest.Id);

            CreateMap<Edition, EditionInfoDto>();
            CreateMap<Edition, EditionListOutput>()
                .Ignore(dest=>dest.TenantCount);
        }
    }
} 