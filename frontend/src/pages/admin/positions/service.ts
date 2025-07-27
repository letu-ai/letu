import httpClient from '@/utils/httpClient';
import type { AppResponse, AppOptionTree, PageSearch, PagedResult } from '@/types/api';

/**
 * 新增职位分组
 * @param dto
 */
export function addPositionGroup(dto: PositionGroupDto) {
  return httpClient.post<PositionGroupDto, AppResponse<boolean>>('/api/admin/positions', dto);
}

/**
 * 职位分组分页列表
 * @param dto
 */
export function getPositionGroupList(dto?: PositionGroupQueryDto) {
  return httpClient.get<PositionGroupQueryDto, AppResponse<PositionGroupListDto[]>>('/api/admin/positions', {
    params: dto,
  });
}

/**
 * 修改职位分组
 * @param dto
 */
export function updatePositionGroup(dto: PositionGroupDto) {
  return httpClient.put<PositionGroupDto, AppResponse<boolean>>('/api/admin/positions', dto);
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


/**
 * 新增职位
 * @param dto
 */
export function addPosition(dto: PositionDto) {
  return httpClient.post<PositionDto, AppResponse<boolean>>('/api/admin/positions', dto);
}

/**
 * 职位分页列表
 * @param dto
 */
export function getPositionList(dto: PositionQueryDto) {
  return httpClient.get<PositionQueryDto, AppResponse<PagedResult<PositionListDto>>>('/api/admin/positions', {
    params: dto,
  });
}

/**
 * 编辑职位
 * @param dto
 */
export function updatePosition(dto: PositionDto) {
  return httpClient.put<PositionDto, AppResponse<boolean>>('/api/admin/positions', dto);
}

/**
 * 删除职位
 * @param id
 */
export function deletePosition(id: string) {
  return httpClient.delete('/api/position/delete/' + id);
}

/**
 * 职位分组+职位树
 */
export function getPositionOptions() {
  return httpClient.get<unknown, AppResponse<AppOptionTree[]>>('/api/position/options');
}

export interface PositionDto {
  id?: string | null;
  name: string;
  code: string;
  level: number;
  status: number;
  description?: string | null;
  groupId?: string | null;
}

export interface PositionQueryDto extends PageSearch {
  keyword?: string | null;
  level?: string | null;
  status?: number | null;
  groupId?: number | null;
}

export interface PositionListDto {
  id: string;
  code: string | null;
  name: string | null;
  level: number;
  status: number;
  description: string;
  groupId: string | null;
  layerName: string | null;
}
