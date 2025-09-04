using AutoMapper;
using Letu.Basis.Admin.DataDictionaries.Dtos;
using Volo.Abp.AutoMapper;

namespace Letu.Basis.Admin.DataDictionaries
{
    public class DictionaryAutoMapperProfile : Profile
    {
        public DictionaryAutoMapperProfile()
        {
            CreateMap<DictionaryCreateInput, DataDictionary>(MemberList.Source)
                .Ignore(dest => dest.Id);

            CreateMap<DictionaryUpdateInput, DataDictionary>(MemberList.Source)
                .Ignore(dest => dest.Id);

            CreateMap<DataDictionary, DictionaryListOutput>();


            CreateMap<ItemCreateOrUpdateInput, DataDictionaryItem>(MemberList.Source)
                .Ignore(dest=>dest.Id);

            CreateMap<DataDictionaryItem, ItemListOutput>();
        }
    }
}