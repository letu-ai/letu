import axios, { AxiosError, type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios';
import UserStore from '@/store/userStore';
import { StaticRoutes } from '@/utils/globalValue.ts';
import { message } from 'antd';
import { refreshToken } from '@/pages/accounts/service';
import ResponseErrorMessage from './ResponseErrorMessage';

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
    code?: string;
    details?: string | string[];
    data?: any;
}

let codeMessage: Record<number, string> = {
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

    if (codeMessage.hasOwnProperty(status))
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
                // 尝试按顺序处理不同类型的错误
                errorInfo = (await getAbpError(error.response)) ||
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
    allowAnonymousApis: string[] = ['/api/account/login']; //允许匿名访问接口
    refreshTokenWhiteApis: string[] = ['/api/account/refresh-token', '/api/account/logout']; //不需要刷新token接口
    private refreshTokenPromise: Promise<any> | null = null; // 防止并发刷新token

    constructor(config?: AxiosRequestConfig) {
        this.instance = axios.create(config);

        // 请求拦截器
        this.instance.interceptors.request.use(
            async (config) => {
                if (config.url && this.allowAnonymousApis.includes(config.url)) {
                    return config;
                }
                //添加token
                const token = UserStore.token?.accessToken;
                const expired = UserStore.token?.expiredTime;
                const now = new Date();
                const expiredTime = expired ? new Date(expired) : null;

                if (token && expiredTime && expiredTime.getTime() > now.getTime()) {
                    config.headers.Authorization = `Bearer ${token}`;
                    //过期时间小于10分钟进行刷新token
                    const tenMinutesFromNow = new Date(now.getTime() + 10 * 60 * 1000);
                    if (expiredTime.getTime() < tenMinutesFromNow.getTime()) {
                        // 打印token剩余过期时间
                        const leftSeconds = Math.floor((expiredTime.getTime() - now.getTime()) / 1000);
                        console.log(`token剩余过期时间：${leftSeconds}秒（统一时间戳比较）`);
                        //如果当前是刷新token接口就不调用，避免循环调用
                        const refreshTokenValue = UserStore.token?.refreshToken;
                        const currentUrl = config.url?.toLowerCase() || '';
                        const isRefreshTokenApi = this.refreshTokenWhiteApis.some(
                            (x) => currentUrl.endsWith(x.toLowerCase())
                        );

                        if (!isRefreshTokenApi && refreshTokenValue) {
                            try {
                                // 防止并发刷新token
                                if (!this.refreshTokenPromise) {
                                    this.refreshTokenPromise = refreshToken(refreshTokenValue)
                                        .then((refreshTokenRes) => {
                                            if (refreshTokenRes) {
                                                UserStore.refreshToken(
                                                    refreshTokenRes.accessToken,
                                                    refreshTokenRes.refreshToken,
                                                    refreshTokenRes.expiredTime,
                                                );
                                            }
                                            return refreshTokenRes;
                                        })
                                        .finally(() => {
                                            // 刷新完成后清除Promise，允许下次刷新
                                            this.refreshTokenPromise = null;
                                        });
                                }
                                await this.refreshTokenPromise;
                            } catch (error) {
                                if (axios.isAxiosError(error) && error.response?.status === 401) {
                                    UserStore.logout();
                                    message.error('登录已过期，请重新登录', 3, () => {
                                        window.location.href = StaticRoutes.Login;
                                    });
                                }
                                // 这里不再继续抛出错误，让请求继续进行
                                // 当前请求会继续发送，但由于token已过期，会在响应拦截器中被捕获并处理
                            }
                        }
                    }
                }
                return config;
            },
            (error) => {
                return Promise.reject(error);
            },
        );

        // 响应拦截器
        this.instance.interceptors.response.use(
            (response) => {
                // /** 统一返回结果响应码不等于成功，中断请求；这样做是确保.then()中是响应成功 */
                // if (response.data.code && response.data.code !== ErrorCode.Success) {
                //   const errMsg = response.data.message ?? '请求失败';
                //   message.error(errMsg);
                //   return Promise.reject(errMsg);
                // }
                return response.data;
            },
            async (error) => {
                const errorInfo = await getErrorInfo(error);
                if (errorInfo.jumpLogin) {
                    UserStore.logout();
                }

                message.error(<ResponseErrorMessage error={errorInfo} />, 3, () => {
                    if (errorInfo.jumpLogin) {
                        window.location.href = StaticRoutes.Login;
                    }
                });
                return Promise.reject(error);
            },
        );
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
    baseURL: getBaseUrl(),
    headers: {
        'Content-Type': 'application/json',
    },
};

function getBaseUrl(){
    const urlTemplate = import.meta.env.VITE_API_BASE_URL;
    const port = import.meta.env.VITE_API_BASE_PORT;
    return urlTemplate.replace(/{{port}}/g, port);
}

// 创建默认实例
const httpClient = new HttpClient(defaultConfig);

export default httpClient;
