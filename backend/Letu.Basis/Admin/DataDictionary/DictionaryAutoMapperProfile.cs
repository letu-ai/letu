using AutoMapper;
using Letu.Basis.Admin.DataDictionary.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.DataDictionary
{
    public class DictionaryAutoMapperProfile : Profile
    {
        public DictionaryAutoMapperProfile()
        {
            CreateMap<ItemCreateOrUpdateInput, DictionaryItem>(MemberList.Source)
                .Ignore(dest=>dest.Id);

            CreateMap<DictionaryItem, ItemListOutput>();

            CreateMap<TypeCreateOrUpdateInput, DictionaryType>(MemberList.Source)
                .Ignore(dest=>dest.Id);

            CreateMap<DictionaryType, TypeListOutput>();
        }
    }
}