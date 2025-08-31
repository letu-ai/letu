export interface RecipientSelectorProps {
  value?: RecipientValue;
  onChange?: (value: RecipientValue) => void;
  disabled?: boolean;
  placeholder?: string;
}

export interface RecipientValue {
  sendScopeType: SendScopeType;
  sendScopeValue?: string;
}

export const SendScopeType = {
  SPECIFIC_USERS: 1,  // 指定用户
  BY_ROLE: 2,         // 按角色
  BY_DEPARTMENT: 3,   // 按部门
  BY_POSITION: 4,     // 按职位
  ALL_USERS: 5,       // 全体用户
} as const;

export type SendScopeType = typeof SendScopeType[keyof typeof SendScopeType]; 

export interface DepartmentTreeNode {
  id: string;
  name: string;
  type?: number;
  label?: string;
  value?: string;
  disabled?: boolean;
  children?: DepartmentTreeNode[];
}

export interface RoleOption {
  id?: string;
  name?: string;
  label: string;
  value: string;
}

export interface PositionOption {
  id?: string;
  name?: string;
  title?: string;
  key?: string;
  label?: string;
  value: string;
}

export interface UserOption {
  id?: string;
  userName?: string;
  nickName?: string;
  email?: string;
  phone?: string;
  isEnabled?: boolean;
  departmentName?: string;
  positionName?: string;
}

export interface RecipientPreview {
  count: number;
  description: string;
}

export interface SelectOption {
  label: string;
  value: string;
}