using AutoMapper;
using Letu.AI.Workflows.Templates.Dtos;

namespace Letu.AI.Workflows.Templates;

public class WorkflowTemplateAutoMapperProfile : Profile
{
    public WorkflowTemplateAutoMapperProfile()
    {
        CreateMap<WorkflowTemplate, WorkflowTemplateOutput>();
    }

}
