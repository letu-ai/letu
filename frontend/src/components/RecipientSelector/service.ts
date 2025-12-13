import httpClient from "@/utils/httpClient";
import type { DepartmentTreeNode, RoleOption, PositionOption, UserOption, SelectOption } from "./types";

/**
 * 获取部门树形数据
 */
export function getDepartmentTree() {
  return httpClient.get<void, DepartmentTreeNode[]>("/api/admin/departments");
}

/**
 * 获取所有角色
 */
export function getAllRoles() {
  return httpClient.get<void, RoleOption[]>("/api/admin/roles/options");
}

/**
 * 获取所有职位
 */
export function getAllPositions() {
  return httpClient.get<void, PositionOption[]>("/api/admin/positions/tree-options");
}

/**
 * 获取所有用户（支持搜索和分页）
 */
export function getAllUsers(params?: { 
  userName?: string; 
  pageSize?: number;
  current?: number;
}) {
  return httpClient.get<any, {
    items: UserOption[];
    totalCount: number;
  }>("/api/admin/users", {
    params: {
      pageSize: 20, // 默认分页大小
      current: 1, // 默认第一页
      ...params,
    },
  });
}

/**
 * 获取用户选项（用于下拉选择，轻量化数据）
 */
export function getUserOptions(keyword?: string) {
  return httpClient.get<void, SelectOption[]>("/api/admin/users/select-options", {
    params: keyword ? { keyword } : {},
  });
}

/**
 * 根据用户ID批量获取用户信息（用于编辑时回显）
 */
export function getUsersByIds(userIds: string[]) {
  return httpClient.post<string[], SelectOption[]>("/api/admin/users/by-ids", userIds);
}

