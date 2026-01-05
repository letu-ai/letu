import httpClient from '@/utils/httpClient';
import type { IHttpClientConfig } from '@/utils/httpClient';
import { getApiBaseUrl } from '@/utils/urlUtils';

export interface IDirectory {
    id: string;
    name: string;
    path: string;
    parentId: string | null;
    children: IDirectory[] | null;
    creationTime: string;
    lastModificationTime: string | null;
}

export interface IFile {
    id: string;
    name: string;
    path: string;
    directoryId: string;
    creationTime: string;
    lastModificationTime: string | null;
}

export interface IFileItem {
    id: string;
    name: string;
    originalName: string;
    path: string;
    directoryId: string | null;
    type: 'Image' | 'Excel' | 'Word' | 'Pdf';
    mimeType: string;
    size: number;
    creationTime: string;
    lastModificationTime: string | null;
    directory?: {
        id: string;
        name: string;
        path: string;
    } | null;
}

export interface ICreateDirectoryInput {
    name: string;
    parentId: string | null;
}

export interface IUpdateDirectoryInput {
    name: string;
}

export interface IRenameDirectoryInput {
    id: string;
    newName: string;
}

/**
 * 获取目录树
 */
export async function getDirectories(config?: IHttpClientConfig): Promise<IDirectory[]> {
    return await httpClient.get<IDirectory[]>('/api/ai/file-manager/directories', config);
}

/**
 * 创建目录
 */
export async function createDirectory(input: ICreateDirectoryInput, config?: IHttpClientConfig): Promise<void> {
    await httpClient.post<ICreateDirectoryInput, void>(
        '/api/ai/file-manager/directories',
        input,
        config
    );
}

/**
 * 更新目录（重命名）
 */
export async function updateDirectory(id: string, input: IUpdateDirectoryInput, config?: IHttpClientConfig): Promise<void> {
    await httpClient.put<IRenameDirectoryInput, void>(
        '/api/ai/file-manager/directories/rename',
        {
            id,
            newName: input.name,
        },
        config
    );
}

/**
 * 删除目录
 */
export async function deleteDirectory(id: string, config?: IHttpClientConfig): Promise<void> {
    await httpClient.delete<void>(`/api/ai/file-manager/directories/${id}`, config);
}

/**
 * 获取文件列表
 */
export async function getFiles(directoryId: string | null, config?: IHttpClientConfig): Promise<IFileItem[]> {
    const url = directoryId
        ? `/api/ai/file-manager/files?directoryId=${directoryId}`
        : '/api/ai/file-manager/files';
    return await httpClient.get<IFileItem[]>(url, config);
}

/**
 * 上传文件
 */
export async function uploadFiles(files: File[], directoryId: string | null, config?: IHttpClientConfig): Promise<IFileItem[]> {
    const formData = new FormData();
    files.forEach((file) => {
        formData.append('files', file);
    });
    if (directoryId) {
        formData.append('directoryId', directoryId);
    }

    const requestConfig: IHttpClientConfig = {
        headers: {
            'Content-Type': 'multipart/form-data',
        },
        ...config,
    };

    return await httpClient.post<FormData, IFileItem[]>('/api/ai/file-manager/files', formData, requestConfig);
}

/**
 * 删除文件
 */
export async function deleteFile(id: string, config?: IHttpClientConfig): Promise<void> {
    return await httpClient.delete<void>(`/api/ai/file-manager/files/${id}`, config);
}

/**
 * 获取文件下载 URL
 */
export function getFileDownloadUrl(fileId: string): string {
    const baseUrl = getApiBaseUrl();
    return `${baseUrl}/api/ai/file-manager/files/${fileId}`;
}


export function getThumbnailUrl(fileId: string): string {
    const baseUrl = getApiBaseUrl();
    return `${baseUrl}/api/ai/file-manager/files/${fileId}/thumbnail`;
}