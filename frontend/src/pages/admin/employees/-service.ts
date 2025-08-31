import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest, SelectOption } from '@/types/api';

/**
 * 新增员工
 * @param dto
 */
export function addEmployee(dto: EmployeeDto) {
  return httpClient.post<EmployeeDto, void>('/api/admin/employees', dto);
}

/**
 * 员工列表
 * @param dto
 */
export function getEmployeePagedList(dto: EmployeeQueryDto) {
  return httpClient.get<EmployeeQueryDto, PagedResult<EmployeeListDto>>('/api/admin/employees', {
    params: dto,
  });
}

/**
 * 搜索员工选项（用于下拉选择搜索）
 * @param keyword 搜索关键词
 */
export function searchEmployeeOptions(keyword?: string) {
  return httpClient.get<{ keyword?: string }, EmployeeSelectOption[]>(
    '/api/admin/employees/select-options',
    { 
      params: { keyword }
    }
  );
}

/**
 * 根据员工ID批量获取员工信息（用于编辑时回填）
 * @param employeeIds 员工ID列表
 */
export function getEmployeesByIds(employeeIds: string[]) {
  return httpClient.post<string[], EmployeeSelectOption[]>(
    '/api/admin/employees/select-options/by-ids',
    employeeIds
  );
}

/**
 * 修改员工
 * @param dto
 */
export function updateEmployee(dto: EmployeeDto) {
  return httpClient.put<EmployeeDto, void>('/api/admin/employees', dto);
}

/**
 * 删除员工
 * @param id
 */
export function deleteEmployee(id: string) {
  return httpClient.delete<void>('/api/admin/employees/' + id);
}


/**
 * 获取员工信息
 * @param id
 */
export function getEmployeeInfo(id: string) {
  return httpClient.get<string, EmployeeInfoDto>(`/api/admin/employees/${id}/info`);
}

/**
 * 部门+员工树形
 * @param dto
 * @returns
 */
export function getDeptEmployeeTree(dto?: DeptEmployeeTreeQueryDto) {
  return httpClient.get<DeptEmployeeTreeQueryDto, DeptEmployeeTreeDto[]>(
    '/api/admin/employees/dept-employee-tree',
    {
      params: dto,
    },
  );
}

export interface EmployeeDto {
  id?: string | null;
  name: string;
  code: string;
  sex: number;
  idNo: string;
  frontIdNoUrl?: string | null;
  backIdNoUrl?: string | null;
  birthday: string;
  address?: string | null;
  inTime?: string | null;
  outTime?: string | null;
  status: number;
}

export interface EmployeeQueryDto extends PagedResultRequest {
  keyword?: string | null;
  departmentId?: string;
}


export interface EmployeeListDto {
  id: string;
  name: string;
  code: string;
  sex: number;
  idNo: string;
  frontIdNoUrl: string | null;
  backIdNoUrl: string | null;
  birthday: string;
  address: string | null;
  inTime: string | null;
  outTime: string | null;
  status: number;
}


export interface EmployeeInfoDto extends EmployeeListDto {
  userName?: string | null;
  nickName?: string | null;
}

export interface DeptEmployeeTreeDto {
  label: string;
  value: string;
  type: number;
  children: DeptEmployeeTreeDto[];
  disabled: boolean;
}

export interface DeptEmployeeTreeQueryDto {
  employeeName?: string;
}


export interface EmployeeSelectOption extends SelectOption {
  code: string;  // 员工工号
}