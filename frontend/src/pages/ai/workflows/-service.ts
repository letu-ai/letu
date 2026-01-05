import httpClient from '@/utils/httpClient';

export interface WorkflowTemplateDto {
  id: string;
  userId: string;
  elsaDefinitionId: string;
  name: string;
  description?: string;
  isDefault: boolean;
  flowData?: string;
  version: number;
  isPublished: boolean;
  lastPublishedTime?: string;
  creationTime: string;
  lastModificationTime?: string;
}

export interface CreateWorkflowTemplateInput {
  name: string;
  description?: string;
  isDefault?: boolean;
  flowData: string;
}

export interface UpdateWorkflowTemplateInput {
  name?: string;
  description?: string;
  isDefault?: boolean;
  flowData?: string;
}

/**
 * 获取工作流模板列表
 */
export function getWorkflowList() {
  return httpClient.get<never, WorkflowTemplateDto[]>('/api/ai/workflows');
}

/**
 * 获取工作流模板详情
 */
export function getWorkflow(id: string) {
  return httpClient.get<never, WorkflowTemplateDto>(`/api/ai/workflows/${id}`);
}

/**
 * 创建工作流模板
 */
export function createWorkflow(input: CreateWorkflowTemplateInput) {
  return httpClient.post<CreateWorkflowTemplateInput, WorkflowTemplateDto>('/api/ai/workflows', input);
}

/**
 * 更新工作流模板
 */
export function updateWorkflow(id: string, input: UpdateWorkflowTemplateInput) {
  return httpClient.put<UpdateWorkflowTemplateInput, WorkflowTemplateDto>(`/api/ai/workflows/${id}`, input);
}

/**
 * 删除工作流模板
 */
export function deleteWorkflow(id: string) {
  return httpClient.delete<never, void>(`/api/ai/workflows/${id}`);
}

/**
 * 发布工作流模板
 */
export function publishWorkflow(id: string) {
  return httpClient.post<never, WorkflowTemplateDto>(`/api/ai/workflows/${id}/publish`);
}

