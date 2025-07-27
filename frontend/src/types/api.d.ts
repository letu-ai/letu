export type AppResponse<T> = {
  code: string;
  message: string;
  data: T
}

export type PagedResult<T> = {
  items: T[];
  totalCount: number;
}

export type PageSearch = {
  pageSize: number;
  current: number;
}

export type AppOption = {
  label: string;
  value: string;
  extra?: never;
};

export type AppOptionTree = {
  label?: string;
  value?: string;
  extra?: never;
  children?: AppOptionTree[];
};