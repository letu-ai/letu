import 'axios'

declare module 'axios' {
  export interface AxiosResponse<T = never> extends Promise<T> {
    data: T
    status: number
    statusText: string
    headers: never
    config: AxiosRequestConfig
    request?: never
  }
}