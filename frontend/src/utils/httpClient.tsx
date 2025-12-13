import axios, { AxiosError, type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios';
import { getToken } from '@/utils/authUtils';
import { getApiBaseUrl } from './urlUtils';
import { refreshToken } from '@/utils/tokenRefreshManager';

// 扩展AxiosRequestConfig，添加anonymous属性
export interface IHttpClientConfig extends AxiosRequestConfig {
    /**
     * 是否为匿名请求（不需要token认证和刷新）
     * 设置为true时，不会添加Authorization header，也不会在401时进行token刷新
     */
    anonymous?: boolean;

    /**
     * 是否显示全局错误消息,true时显示全局错误消息
     * 默认值为true
     */
    showGlobalErrorMessage?: boolean;
}

interface IAbpFormatError {
    message: string;
    code: string;
    details: string;
    data: any;
    validationErrors: []
}

export interface IResponseError {
    message: string;
    jumpLogin?: boolean;
    jumpTenantError?: boolean;
    showGlobalErrorMessage?: boolean;
    code?: string;
    details?: string | string[];
    data?: any;
}

const codeMessage: Record<number, string> = {
    200: "服务器成功返回请求的数据。",
    201: "新建或修改数据成功。",
    202: "一个请求已经进入后台排队（异步任务）。",
    204: "删除数据成功。",
    400: "发出的请求有错误，服务器没有进行新建或修改数据的操作。",
    401: "用户没有登录（令牌、用户名、密码错误等）。",
    403: "用户访问被禁止。",
    404: "没有找到访问的资源。",
    406: "请求的格式不可得。",
    410: "请求的资源被永久删除，且不会再得到的。",
    422: "当创建一个对象时，发生一个验证错误。",
    500: "服务器发生错误，请稍后再试。",
    502: "网关错误。",
    503: "服务不可用，请稍后再试。",
    504: "网关超时。",
};

const getStatusMessage = (status?: number): string => {
    if (!status)
        return "未知错误";

    if (Object.prototype.hasOwnProperty.call(codeMessage, status))
        return codeMessage[status];
    else
        return `未知错误:[${status}]`;
}

const getValidateError = (response: AxiosResponse): IResponseError | undefined => {
    // 使用RFC标准的type字段判断是否为验证错误
    if (response.data && response.data.type === "https://tools.ietf.org/html/rfc9110#section-15.5.1" && response.data.errors) {
        // 处理验证错误
        const errors = response.data.errors;

        // 将错误对象转换为字符串数组
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
            jumpLogin: false
        };
    }

    return undefined;
}

// 获取租户解析错误
const getTenantResolveError = (response: AxiosResponse): IResponseError | undefined => {
    // 检查是否存在租户解析错误头
    const tenantResolveError = response.headers["abp-tenant-resolve-error"];
    if (tenantResolveError) {
        return {
            message: `租户解析错误：${decodeURIComponent(tenantResolveError)}`,
            jumpTenantError: true,
            code: response.status.toString(),
            jumpLogin: false
        };
    }

    return undefined;
}

const getAbpError = async (response: AxiosResponse): Promise<IResponseError | undefined> => {
    if (response.headers["_abperrorformat"] === "true") {
        // 处理ABP框架已经格式化好的错误。
        const abpError = response.data.error as IAbpFormatError;
        return {
            message: abpError.message,
            code: abpError.code,
            details: abpError.details,
            data: abpError.data,
            jumpLogin: false
        };
    }

    return undefined;
}

// 获取通用HTTP状态码错误信息
const getHttpStatusError = (status: number): IResponseError => {
    return { message: getStatusMessage(status), jumpLogin: status === 401 };
}

// 综合错误信息处理
export const getErrorInfo = async (error: AxiosError): Promise<IResponseError> => {
    let errorInfo: IResponseError = {
        message: '异常错误，请联系管理员',
        jumpLogin: false
    };

    switch (error.code) {
        case 'ERR_NETWORK':
            errorInfo.message = '网络错误，请联系管理员';
            break;
        case 'ERR_BAD_REQUEST':
        case 'ERR_BAD_RESPONSE':
            if (error.response) {
                // 尝试按顺序处理不同类型的错误，租户解析错误优先级最高
                errorInfo = getTenantResolveError(error.response) ||
                    (await getAbpError(error.response)) ||
                    getValidateError(error.response) ||
                    getHttpStatusError(error.response.status);
            }
            break;
        default:
            errorInfo.message = '未知异常错误，请联系管理员';
            break;
    }

    return errorInfo;
}

// ==================== 适配函数 ====================

/**
 * 从存储中获取accessToken
 */
function getAccessTokenFromStore(): string | null {
    const token = getToken();
    return token?.accessToken || null;
}


// ==================== 默认配置 ====================

const defaultConfig: AxiosRequestConfig = {
    baseURL: getApiBaseUrl(),
    headers: {
        'Content-Type': 'application/json',
    },
    timeout: 10000,
};

// 创建axios实例
const instance = axios.create(defaultConfig);

// 使用闭包维护状态
let errorHandler: (error: IResponseError) => void = () => { };
let isRefreshing = false;
let requests: Array<() => void> = [];

// 请求拦截器：在发送请求之前，从存储获取 token 并添加到请求头
instance.interceptors.request.use(
    config => {
        const httpConfig = config as IHttpClientConfig;
        // 如果是匿名请求，不添加token
        if (httpConfig.anonymous) {
            return config;
        }
        const accessToken = getAccessTokenFromStore();
        if (accessToken) {
            config.headers = config.headers || {};
            config.headers['Authorization'] = `Bearer ${accessToken}`;
        }
        return config;
    },
    error => Promise.reject(error)
);

// 响应拦截器：处理401错误，实现双token刷新机制
instance.interceptors.response.use(
    response => response.data, // 对成功响应直接返回data
    async error => {
        const config = error?.config as IHttpClientConfig | undefined;
        const status = error?.response?.status as number | undefined;
        const showGlobalErrorMessage = config?.showGlobalErrorMessage ?? true;

        // 1. 如果不是 401 错误，直接返回错误
        if (status !== 401) {
            const errorInfo = await getErrorInfo(error);
            errorInfo.showGlobalErrorMessage = showGlobalErrorMessage;
            errorHandler(errorInfo);
            return Promise.reject(error);
        }

        // 2. 如果没有config或config无效，直接返回错误
        if (!config) {
            const errorInfo = await getErrorInfo(error);
            errorInfo.showGlobalErrorMessage = showGlobalErrorMessage;
            errorHandler(errorInfo);
            return Promise.reject(error);
        }

        // 3. 如果是匿名请求，不进行token刷新，直接返回错误
        if (config.anonymous) {
            const errorInfo = await getErrorInfo(error);
            errorInfo.showGlobalErrorMessage = showGlobalErrorMessage;
            errorHandler(errorInfo);
            return Promise.reject(error);
        }

        // 4. 避免重复刷新：如果正在刷新 token，将后续请求暂存
        if (isRefreshing) {
            return new Promise(resolve => {
                requests.push(() => resolve(instance.request(config)));
            });
        }

        isRefreshing = true;

        try {
            // 5. 使用 tokenRefreshManager 刷新 token
            const refreshSuccess = await refreshToken();

            if (!refreshSuccess) {
                throw new Error('刷新token失败');
            }

            // 6. 从存储中获取更新后的 access token
            const updatedToken = getToken();
            if (!updatedToken?.accessToken) {
                throw new Error('刷新token后无法获取新的accessToken');
            }

            // 7. 更新请求头中的 token
            config.headers = config.headers || {};
            config.headers['Authorization'] = `Bearer ${updatedToken.accessToken}`;

            // 8. 重新执行所有被挂起的请求
            requests.forEach(cb => cb());
            requests = []; // 清空队列

            // 9. 重试刚才失败的请求
            return instance.request(config);
        } catch (refreshError) {
            // 10. 如果刷新 token 也失败了，则执行登出操作
            console.error('刷新token失败，', refreshError);
            requests = []; // 清空队列
            const errorInfo: IResponseError = {
                message: '登录已过期，请重新登录',
                jumpLogin: true,
                showGlobalErrorMessage: showGlobalErrorMessage
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
    get: <TRequest = any, TResponse = any>(url: string, config?: IHttpClientConfig): Promise<TResponse> => {
        return instance.get<TRequest, TResponse>(url, config);
    },
    post: <TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: IHttpClientConfig,
    ): Promise<TResponse> => {
        return instance.post<TRequest, TResponse>(url, data, config);
    },
    put: <TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: IHttpClientConfig,
    ): Promise<TResponse> => {
        return instance.put<TRequest, TResponse>(url, data, config);
    },
    delete: <TRequest = any, TResponse = any>(url: string, config?: IHttpClientConfig): Promise<TResponse> => {
        return instance.delete<TRequest, TResponse>(url, config);
    },
    patch: <TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: IHttpClientConfig,
    ): Promise<TResponse> => {
        return instance.patch<TRequest, TResponse>(url, data, config);
    },
    getInstance: (): AxiosInstance => instance,
};

export default httpClient;
