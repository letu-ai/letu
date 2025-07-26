import httpClient from '@/utils/httpClient';
import type { AppResponse } from '@/types/api';

/**
 * 新增职位分组
 * @param dto
 */
export function addPositionGroup(dto: PositionGroupDto) {
  return httpClient.post<PositionGroupDto, AppResponse<boolean>>('/api/positionGroup/add', dto);
}

/**
 * 职位分组分页列表
 * @param dto
 */
export function getPositionGroupList(dto?: PositionGroupQueryDto) {
  return httpClient.get<PositionGroupQueryDto, AppResponse<PositionGroupListDto[]>>('/api/positionGroup/list', {
    params: dto,
  });
}

/**
 * 修改职位分组
 * @param dto
 */
export function updatePositionGroup(dto: PositionGroupDto) {
  return httpClient.put<PositionGroupDto, AppResponse<boolean>>('/api/positionGroup/update', dto);
}

/**
 * 删除职位分组
 * @param id
 */
export function deletePositionGroup(id: string) {
  return httpClient.delete<AppResponse<boolean>>(`/api/positionGroup/delete/${id}`);
}

export interface PositionGroupDto {
  id?: string | null;
  parentId?: string | null;
  groupName: string;
  remark?: string | null;
  sort: number;
}

export interface PositionGroupQueryDto {
  groupName?: string | null;
}

export interface PositionGroupListDto {
  id: string;
  groupName: string;
  remark: string | null;
  parentId: string | null;
  sort: number;
  positionGroupListDto: PositionGroupDto[];
}
