import httpClient from '@/utils/httpClient';

/**
 * 新增部门
 * @param dto
 */
export function addDept(dto: DeptDto) {
  return httpClient.post<DeptDto, void>('/api/admin/departments', dto);
}

/**
 * 部门树形列表
 * @param dto
 */
export function getDeptList(dto: DeptQueryDto) {
  return httpClient.get<DeptQueryDto, DeptListDto[]>('/api/admin/departments', { params: dto });
}

/**
 * 修改部门
 * @param input
 */
export function updateDept(id: string, input: DeptDto) {
  return httpClient.put<DeptDto, void>(`/api/admin/departments/${id}`, input);
}

/**
 * 删除部门
 * @param id 部门ID
 */
export function deleteDept(id: string) {
  return httpClient.delete<string, void>(`/api/admin/departments/${id}`);
}

export interface DeptDto {
  id?: string | null;
  name: string;
  code: string;
  sort: number;
  description?: string | null;
  status: number;
  curatorId?: string | null;
  email?: string | null;
  phone?: string | null;
  parentId?: string | null;
}

export interface DeptQueryDto {
  id?: string | null;
  code?: string | null;
  name?: string | null;
  status?: number;
}

export interface DeptListDto {
  id: string;
  code: string;
  name: string;
  sort: number;
  description: string | null;
  status: number;
  curatorId: string | null;
  curatorName: string | null;
  email: string | null;
  phone: string | null;
  parentId: string | null;
  children?: DeptListDto[];
}