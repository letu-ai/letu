import axios, { AxiosError, type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios';
import { getToken, shouldRefreshToken } from '@/utils/authUtils';
import { getApiBaseUrl } from './urlUtils';
import { tokenRefreshManager } from './tokenRefreshManager';

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
const getErrorInfo = async (error: AxiosError): Promise<IResponseError> => {
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

class HttpClient {
    private readonly instance: AxiosInstance;
    refreshTokenWhiteApis: string[] = [ //不需要刷新token接口
        '/api/identity/login',
        '/api/identity/refresh-token',
        '/api/identity/logout',
        "/api/application/configuration"
    ]; 
    private errorHandler: (error: IResponseError) => void = () => { };

    // 工具函数：统一URL小写；是否“跳过刷新token”的接口（匿名 或 刷新/注销）
    private toUrl(url?: string): string { return (url || '').toLowerCase(); }
    private isSkipRefreshApi(url?: string): boolean {
        const u = this.toUrl(url);
        return this.refreshTokenWhiteApis.some(x => u.endsWith(x.toLowerCase()));
    }

    // 工具函数：给请求附带当前本地token（即使已过期也附带）
    private attachTokenHeader(config: AxiosRequestConfig) {
        const token = getToken();
        if (token?.accessToken) {
            config.headers = config.headers || {};
            (config.headers as any).Authorization = `Bearer ${token.accessToken}`;
        }
    }

    // 使用共享的token刷新管理器
    private async refreshTokenInternal(): Promise<boolean> {
        return tokenRefreshManager.refreshToken();
    }

    // 处理请求前：受保护接口需要确保token有效；匿名/刷新白名单跳过"刷新token"
    private async prepareAuthForRequest(config: AxiosRequestConfig): Promise<void> {
        const skipRefresh = this.isSkipRefreshApi(config.url);
        
        // 如果不是白名单接口，检查是否需要刷新token
        if (!skipRefresh && shouldRefreshToken()) {
            const refreshed = await this.refreshTokenInternal();
            if (!refreshed) {
                const token = getToken();
                // 如果刷新失败且token已过期，抛出错误
                if (!token || !token.accessToken) {
                    const err = new Error('Token is invalid or expired');
                    err.name = 'TokenInvalidError';
                    throw err;
                }
            }
        }

        // 无论是否匿名/刷新白名单，都附带当前本地token（如果有的话）
        this.attachTokenHeader(config);
    }

    // 响应401时尝试刷新并重试一次（排除“跳过刷新token”的接口）
    private async tryRefreshAndRetry(error: any): Promise<any> {
        const originalConfig = error?.config as (AxiosRequestConfig & { __isRetry?: boolean }) | undefined;
        const status = error?.response?.status as number | undefined;
        if (!originalConfig || status !== 401) return Promise.reject(error);

        const skipRefresh = this.isSkipRefreshApi(originalConfig.url);
        if (skipRefresh || originalConfig.__isRetry) {
            return Promise.reject(error);
        }

        try {
            const refreshed = await this.refreshTokenInternal();
            if (!refreshed) {
                const tokenError: IResponseError = { message: '登录已过期，请重新登录', jumpLogin: true };
                this.errorHandler(tokenError);
                return Promise.reject(error);
            }

            // 使用最新token重试一次
            this.attachTokenHeader(originalConfig);
            originalConfig.__isRetry = true;
            return this.instance.request(originalConfig);
        } catch {
            const tokenError: IResponseError = { message: '登录已过期，请重新登录', jumpLogin: true };
            this.errorHandler(tokenError);
            return Promise.reject(error);
        }
    }

    constructor(config?: AxiosRequestConfig) {
        this.instance = axios.create(config);

        // 请求拦截器
        this.instance.interceptors.request.use(
            async (config) => {
                await this.prepareAuthForRequest(config);
                return config;
            },
            (error) => Promise.reject(error),
        );

        // 响应拦截器
        this.instance.interceptors.response.use(
            (response) => {
                return response.data;
            },
            async (error) => {
                // 401兜底重试
                const maybeRetried = await this.tryRefreshAndRetry(error).catch(() => undefined);
                if (maybeRetried !== undefined) 
                    return maybeRetried;

                const errorInfo = await getErrorInfo(error);
                this.errorHandler(errorInfo);
                return Promise.reject(error);
            },
        );
    }

    public setErrorHandler(handler: (error: IResponseError) => void) {
        this.errorHandler = handler;
    }

    // GET请求
    public get<TRequest = any, TResponse = any>(url: string, config?: AxiosRequestConfig): Promise<TResponse> {
        return this.instance.get<TRequest, TResponse>(url, config);
    }

    // POST请求
    public post<TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: AxiosRequestConfig,
    ): Promise<TResponse> {
        return this.instance.post<TRequest, TResponse>(url, data, config);
    }

    // PUT请求
    public put<TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: AxiosRequestConfig,
    ): Promise<TResponse> {
        return this.instance.put<TRequest, TResponse>(url, data, config);
    }

    // DELETE请求
    public delete<TRequest = any, TResponse = any>(url: string, config?: AxiosRequestConfig): Promise<TResponse> {
        return this.instance.delete<TRequest, TResponse>(url, config);
    }

    // PATCH请求
    public patch<TRequest = any, TResponse = any>(
        url: string,
        data?: any,
        config?: AxiosRequestConfig,
    ): Promise<TResponse> {
        return this.instance.patch<TRequest, TResponse>(url, data, config);
    }

    // 获取原始Axios实例
    public getInstance(): AxiosInstance {
        return this.instance;
    }
}

// 默认配置
const defaultConfig: AxiosRequestConfig = {
    baseURL: getApiBaseUrl(),
    headers: {
        'Content-Type': 'application/json',
    }
};

// 创建默认实例
const httpClient = new HttpClient(defaultConfig);

export default httpClient;
