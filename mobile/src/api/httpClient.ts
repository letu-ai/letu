/**
 * HTTP 客户端（Axios 封装）
 * 参考 frontend/src/utils/httpClient.tsx
 */
import axios, { AxiosError, type AxiosInstance, type AxiosRequestConfig } from 'axios';
import { getApiBaseUrl } from '../utils/config';
import { storage } from '../utils/storage';
import { useAuthStore } from '../stores/authStore';
import type { IUserTokenOutput } from '@/pages/auth/service';

// 扩展AxiosRequestConfig
export interface IHttpClientConfig extends AxiosRequestConfig {
  /**
   * 是否为匿名请求（不需要token认证和刷新）
   */
  anonymous?: boolean;

  /**
   * 是否显示全局错误消息
   */
  showGlobalErrorMessage?: boolean;
}

export interface IResponseError {
  message: string;
  code?: string;
  details?: string | string[];
  data?: any;
  showGlobalErrorMessage?: boolean;
}

const codeMessage: Record<number, string> = {
  200: '服务器成功返回请求的数据。',
  201: '新建或修改数据成功。',
  202: '一个请求已经进入后台排队（异步任务）。',
  204: '删除数据成功。',
  400: '发出的请求有错误，服务器没有进行新建或修改数据的操作。',
  401: '用户没有登录（令牌、用户名、密码错误等）。',
  403: '用户访问被禁止。',
  404: '没有找到访问的资源。',
  406: '请求的格式不可得。',
  410: '请求的资源被永久删除，且不会再得到的。',
  422: '当创建一个对象时，发生一个验证错误。',
  500: '服务器发生错误，请稍后再试。',
  502: '网关错误。',
  503: '服务不可用，请稍后再试。',
  504: '网关超时。',
};

const getStatusMessage = (status?: number): string => {
  if (!status) return '未知错误';
  return codeMessage[status] || `未知错误:[${status}]`;
};

const getValidateError = (response: any): IResponseError | undefined => {
  if (response.data && response.data.type === 'https://tools.ietf.org/html/rfc9110#section-15.5.1' && response.data.errors) {
    const errors = response.data.errors;
    const errorDetails: string[] = [];
    for (const field in errors) {
      if (Object.prototype.hasOwnProperty.call(errors, field)) {
        const fieldErrors = errors[field];
        fieldErrors.forEach((err: string) => {
          errorDetails.push(`${field}: ${err}`);
        });
      }
    }
    return {
      message: '数据验证错误，请检查输入内容',
      details: errorDetails,
      code: response.status.toString(),
    };
  }
  return undefined;
};

const getAbpError = (response: any): IResponseError | undefined => {
  if (response.headers?.['_abperrorformat'] === 'true') {
    const abpError = response.data.error;
    return {
      message: abpError.message,
      code: abpError.code,
      details: abpError.details,
      data: abpError.data,
    };
  }
  return undefined;
};

const getErrorInfo = async (error: AxiosError): Promise<IResponseError> => {
  let errorInfo: IResponseError = {
    message: '异常错误，请联系管理员',
  };

  switch (error.code) {
    case 'ERR_NETWORK':
      errorInfo.message = '网络错误，请联系管理员';
      break;
    case 'ERR_BAD_REQUEST':
    case 'ERR_BAD_RESPONSE':
      if (error.response) {
        errorInfo =
          getAbpError(error.response) ||
          getValidateError(error.response) ||
          {
            message: getStatusMessage(error.response.status),
            code: error.response.status.toString(),
          };
      }
      break;
    default:
      errorInfo.message = '未知异常错误，请联系管理员';
      break;
  }

  return errorInfo;
};

// 默认配置
const defaultConfig: AxiosRequestConfig = {
  baseURL: getApiBaseUrl(),
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000,
};

// 创建axios实例
const instance: AxiosInstance = axios.create(defaultConfig);

// 使用闭包维护状态
let errorHandler: (error: IResponseError) => void = () => {};
let isRefreshing = false;
let requests: Array<() => void> = [];

/**
 * 刷新Token
 */
async function performTokenRefresh(refreshTokenValue: string): Promise<boolean> {
  try {
    const response = await axios.post<IUserTokenOutput>(
      `${getApiBaseUrl()}/api/identity/refresh-token`,
      { refreshToken: refreshTokenValue },
      {
        headers: {
          'Content-Type': 'application/json',
        },
        timeout: 30000,
      }
    );

    if (response.data && response.data.accessToken) {
      await useAuthStore.getState().login(response.data);
      return true;
    }
    return false;
  } catch (error) {
    console.error('刷新token失败，', error);
    return false;
  }
}

// 请求拦截器
instance.interceptors.request.use(
  async (config) => {
    const httpConfig = config as IHttpClientConfig;
    if (httpConfig.anonymous) {
      return config;
    }

    const accessToken = await storage.getAccessToken();
    if (accessToken) {
      config.headers = config.headers || {};
      config.headers['Authorization'] = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// 响应拦截器
instance.interceptors.response.use(
  (response) => response.data,
  async (error: AxiosError) => {
    const config = error?.config as IHttpClientConfig | undefined;
    const status = error?.response?.status as number | undefined;
    const showGlobalErrorMessage = config?.showGlobalErrorMessage ?? true;

    if (status !== 401) {
      const errorInfo = await getErrorInfo(error);
      errorInfo.showGlobalErrorMessage = showGlobalErrorMessage;
      errorHandler(errorInfo);
      return Promise.reject(error);
    }

    if (!config || config.anonymous) {
      const errorInfo = await getErrorInfo(error);
      errorInfo.showGlobalErrorMessage = showGlobalErrorMessage;
      errorHandler(errorInfo);
      return Promise.reject(error);
    }

    if (isRefreshing) {
      return new Promise((resolve) => {
        requests.push(() => resolve(instance.request(config)));
      });
    }

    isRefreshing = true;

    try {
      const refreshTokenValue = await storage.getRefreshToken();
      if (!refreshTokenValue) {
        throw new Error('没有找到refreshToken');
      }

      const refreshSuccess = await performTokenRefresh(refreshTokenValue);
      if (!refreshSuccess) {
        throw new Error('刷新token失败');
      }

      const updatedToken = await storage.getAccessToken();
      if (!updatedToken) {
        throw new Error('刷新token后无法获取新的accessToken');
      }

      config.headers = config.headers || {};
      config.headers['Authorization'] = `Bearer ${updatedToken}`;

      requests.forEach((cb) => cb());
      requests = [];

      return instance.request(config);
    } catch (refreshError) {
      console.error('刷新token失败，', refreshError);
      requests = [];
      await useAuthStore.getState().logout();
      const errorInfo: IResponseError = {
        message: '登录已过期，请重新登录',
        showGlobalErrorMessage: showGlobalErrorMessage,
      };
      errorHandler(errorInfo);
      return Promise.reject(refreshError);
    } finally {
      isRefreshing = false;
    }
  }
);

// 导出httpClient对象
const httpClient = {
  setErrorHandler: (handler: (error: IResponseError) => void) => {
    errorHandler = handler;
  },
  get: <TRequest = any, TResponse = any>(
    url: string,
    config?: IHttpClientConfig
  ): Promise<TResponse> => {
    return instance.get<TRequest, TResponse>(url, config);
  },
  post: <TRequest = any, TResponse = any>(
    url: string,
    data?: any,
    config?: IHttpClientConfig
  ): Promise<TResponse> => {
    return instance.post<TRequest, TResponse>(url, data, config);
  },
  put: <TRequest = any, TResponse = any>(
    url: string,
    data?: any,
    config?: IHttpClientConfig
  ): Promise<TResponse> => {
    return instance.put<TRequest, TResponse>(url, data, config);
  },
  delete: <TRequest = any, TResponse = any>(
    url: string,
    config?: IHttpClientConfig
  ): Promise<TResponse> => {
    return instance.delete<TRequest, TResponse>(url, config);
  },
  patch: <TRequest = any, TResponse = any>(
    url: string,
    data?: any,
    config?: IHttpClientConfig
  ): Promise<TResponse> => {
    return instance.patch<TRequest, TResponse>(url, data, config);
  },
  getInstance: (): AxiosInstance => instance,
};

export default httpClient;

