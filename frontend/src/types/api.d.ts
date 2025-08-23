export type PagedResult<T> = {
  items: T[];
  totalCount: number;
}

export type PagedResultRequest = {
  pageSize: number;
  current: number;
}

export type SelectOption = {
  label: string;
  value: string;
};

export type TreeSelectOption = {
  key: string;
  title: string;
  value: string;
  children?: TreeSelectOption[];
};