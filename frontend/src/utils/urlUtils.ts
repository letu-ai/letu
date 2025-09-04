export function getApiBaseUrl() {
    const urlTemplate = import.meta.env.VITE_API_BASE_URL;
    const port = import.meta.env.VITE_API_PORT;
    let url = urlTemplate.replace(/{{port}}/g, port);
    url = url.endsWith('/') ? url.slice(0, -1) : url;
    return url;
}

export function getOssBaseUrl() {
    const urlTemplate = import.meta.env.VITE_OSS_BASE_URL;
    const port = import.meta.env.VITE_OSS_PORT;
    let url = urlTemplate.replace(/{{port}}/g, port);
    url = url.endsWith('/') ? url.slice(0, -1) : url;
    return url;
}