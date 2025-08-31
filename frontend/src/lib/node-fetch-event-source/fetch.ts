/// <reference lib="dom" />

import { type EventSourceMessage, getBytes, getLines, getMessages } from './parse';
import crossFetch from 'cross-fetch'

export const EventStreamContentType = 'text/event-stream';

const DefaultRetryInterval = 1000;
const LastEventId = 'last-event-id';

export interface FetchEventSourceInit extends RequestInit {
    /**
     * The request headers. FetchEventSource only supports the Record<string,string> format.
     */
    headers?: HeadersInit,

    /**
     * Called when a response is received. Use this to validate that the response
     * actually matches what you expect (and throw if it doesn't.) If not provided,
     * will default to a basic validation to ensure the content-type is text/event-stream.
     */
    onopen?: (response: Response) => Promise<void>,

    /**
     * Called when a message is received. NOTE: Unlike the default browser
     * EventSource.onmessage, this callback is called for _all_ events,
     * even ones with a custom `event` field.
     */
    onmessage?: (ev: EventSourceMessage) => Promise<void>;

    /**
     * Called when a response finishes. If you don't expect the server to kill
     * the connection, you can throw an exception here and retry using onerror.
     */
    onclose?: () => void;

    /**
     * Called when there is any error making the request / processing messages /
     * handling callbacks etc. Use this to control the retry strategy: if the
     * error is fatal, rethrow the error inside the callback to stop the entire
     * operation. Otherwise, you can return an interval (in milliseconds) after
     * which the request will automatically retry (with the last-event-id).
     * If this callback is not specified, or it returns undefined, fetchEventSource
     * will treat every error as retriable and will try again after 1 second.
     */
    onerror?: (err: any) => number | null | undefined | void,

    /**
     * If true, will keep the request open even if the document is hidden.
     * By default, fetchEventSource will close the request and reopen it
     * automatically when the document becomes visible again.
     */
    openWhenHidden?: boolean;

    /** The Fetch function to use. Defaults to window.fetch */
    fetch?: typeof fetch;
}

export async function fetchEventSource(input: RequestInfo, {
    signal: inputSignal,
    headers: inputHeaders,
    onopen: inputOnOpen,
    onmessage,
    onclose,
    onerror,
    openWhenHidden,
    fetch: inputFetch,
    ...rest
}: FetchEventSourceInit) {
    return new Promise<void>((resolve, reject) => {
        // make a copy of the input headers since we may modify it below:
        const headers = { ...inputHeaders };
        if (!isKeyInHeaders(headers, 'accept')) {
            setHeaderValue('accept', EventStreamContentType, headers);
        }
        let curRequestController: AbortController;
        function onVisibilityChange() {
            curRequestController.abort(); // close existing request on every visibility change
            if (!document.hidden) {
                create(); // page is now visible again, recreate request.
            }
        }

        if ((typeof document !== 'undefined') && !openWhenHidden) {
            document.addEventListener('visibilitychange', onVisibilityChange);
        }

        let retryInterval = DefaultRetryInterval;
        let retryTimer = undefined as any | undefined;
        function dispose() {
            if ((typeof document !== 'undefined') && !openWhenHidden) {
                document.removeEventListener('visibilitychange', onVisibilityChange);
            }
            clearTimeout(retryTimer);
            curRequestController.abort();
        }

        // if the incoming signal aborts, dispose resources and resolve:
        inputSignal?.addEventListener('abort', () => {
            dispose();
            resolve(); // don't waste time constructing/logging errors
        });

        const fetchFn = (() => {
            if (inputFetch) return inputFetch;
            if (typeof fetch !== 'undefined') return fetch;
            return crossFetch;
        })()

        const onopen = inputOnOpen ?? defaultOnOpen;
        async function create() {
            curRequestController = new AbortController();
            try {
                const response = await fetchFn(input, {
                    ...rest,
                    headers,
                    signal: curRequestController.signal,
                });

                await onopen(response);

                // 分开函数调用以提高可读性和调试性
                const handleId = (id: string) => {
                    if (id) {
                        // store the id and send it back on the next retry:
                        setHeaderValue(LastEventId, id, headers);
                    } else {
                        // don't send the last-event-id header anymore:
                        removeHeader(headers, LastEventId);
                    }
                };
                
                const handleRetry = (retry: number) => {
                    retryInterval = retry;
                };
                
                const messagesHandler = getMessages(handleId, handleRetry, onmessage);
                const linesHandler = getLines(messagesHandler);
                
                await getBytes(response.body!, linesHandler);

                onclose?.();
                dispose();
                resolve();
            } catch (err) {
                if (!curRequestController.signal.aborted) {
                    // if we haven't aborted the request ourselves:
                    try {
                        // check if we need to retry:
                        const interval: any = onerror?.(err) ?? retryInterval;
                        clearTimeout(retryTimer);
                        retryTimer = setTimeout(create, interval);
                    } catch (innerErr) {
                        // we should not retry anymore:
                        dispose();
                        reject(innerErr);
                    }
                }
            }
        }

        create();
    });
}

async function defaultOnOpen(response: Response) {
    const contentType = response.headers.get('content-type');
    if (!contentType?.startsWith(EventStreamContentType)) {
        throw new Error(`Expected content-type to be ${EventStreamContentType}, Actual: ${contentType}`);
    }
}

const isKeyInHeaders = (headers: HeadersInit | undefined, key: string): boolean => {
    if (!headers)
        return false;

    if (headers instanceof Headers)
        return Array.from(headers.keys()).some(k => k.toLowerCase() === key.toLowerCase());
    else if (Array.isArray(headers))
        return headers.find(([k]) => k.toLowerCase() === key.toLowerCase()) !== undefined;
    else if (typeof headers === "object")
        return Object.keys(headers).some(k => k.toLowerCase() === key.toLowerCase());
    else
        return false;
}

function removeHeader(headers: HeadersInit | undefined, key: string) {
    if (!isKeyInHeaders(headers, key))
        return;

    if (headers instanceof Headers)
        headers.delete(key);
    else if (Array.isArray(headers))
        headers = headers.filter(([k]) => k !== key);
    else if (typeof headers === "object")
        delete headers[key];
}

function setHeaderValue(name: string, value: string, targetHeaders: HeadersInit) {
    if (targetHeaders instanceof Headers) {
        targetHeaders.set(name, value);
    } else if (Array.isArray(targetHeaders)) {
        targetHeaders.push([name, value]);
    } else if (typeof targetHeaders === 'object') {
        (targetHeaders as Record<string, string>)[name] = value;
    }
}

