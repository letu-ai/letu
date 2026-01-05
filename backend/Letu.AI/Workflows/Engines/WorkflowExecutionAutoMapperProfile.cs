using AutoMapper;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Dtos;
using Letu.AI.WorkflowTemplates.WorkflowEngines.Entities;
using Volo.Abp.AutoMapper;

namespace Letu.AI.Workflows.Engines;

public class WorkflowExecutionAutoMapperProfile : Profile
{
    public WorkflowExecutionAutoMapperProfile()
    {
        CreateMap<ExecutionMessage, ExecutionMessageDto>()
            .ForMember(dest => dest.InstanceId, opt => opt.MapFrom(src => src.InstanceId))
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.Role))
            .ForMember(dest => dest.Content, opt => opt.MapFrom(src => src.Content))
            .ForMember(dest => dest.NodeId, opt => opt.MapFrom(src => src.NodeId))
            .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(src => src.CreationTime));
    }
}

