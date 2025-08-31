/// <reference lib="dom" />

/**
 * Represents a message sent in an event stream
 * https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format
 */
export interface EventSourceMessage {
    /** The event ID to set the EventSource object's last event ID value. */
    id: string;
    /** A string identifying the type of event described. */
    event: string;
    /** The event data */
    data: string;
    /** The reconnection interval (in milliseconds) to wait before retrying the connection */
    retry?: number;
}

/**
 * Converts a ReadableStream into a callback pattern.
 * @param stream The input ReadableStream.
 * @param onChunk A function that will be called on each new byte chunk in the stream.
 * @returns {Promise<void>} A promise that will be resolved when the stream closes.
 */
export async function getBytes(stream: ReadableStream<Uint8Array>, onChunk: (arr: Uint8Array) => void | Promise<void>) {
    if ('getReader' in stream) {
        const reader = stream.getReader();
        let result: Awaited<ReturnType<typeof reader.read>>;
        while (!(result = await reader.read()).done) {
            await Promise.resolve(onChunk(result.value));
        }
        return
    }

    // see https://github.com/Azure/fetch-event-source/pull/28#issuecomment-1421976714
    if (typeof stream[Symbol.asyncIterator] === 'function') {
        for await (const chunk of stream as any) {
            await Promise.resolve(onChunk(chunk));
        }
        return
    }

    throw new Error('Unsupported stream type, The stream does not have a reader or async iterator.');
}

const ControlChars = {
    NewLine: 10,
    CarriageReturn: 13,
    Space: 32,
    Colon: 58,
} as const;

/** 
 * Parses arbitary byte chunks into EventSource line buffers.
 * Each line should be of the format "field: value" and ends with \r, \n, or \r\n. 
 * @param onLine A function that will be called on each new EventSource line.
 * @returns A function that should be called for each incoming byte chunk.
 */
export function getLines(onLine: (line: Uint8Array, fieldLength: number) => Promise<void>) {
    let buffer: Uint8Array | undefined;
    let position: number; // current read position
    let fieldLength: number; // length of the `field` portion of the line
    let discardTrailingNewline = false;
    let processing = false;
    const queue: Array<{ line: Uint8Array, fieldLength: number }> = [];

    // 处理队列中的一项
    async function processQueue() {
        if (processing || queue.length === 0) return;

        processing = true;
        const item = queue.shift()!;

        try {
            await onLine(item.line, item.fieldLength);
        } catch (e) {
            console.error("Error processing line:", e);
        } finally {
            processing = false;
            // 继续处理队列中的下一项
            processQueue();
        }
    }

    // return a function that can process each incoming byte chunk:
    return function onChunk(arr: Uint8Array) {
        if (buffer === undefined) {
            buffer = arr;
            position = 0;
            fieldLength = -1;
        } else {
            // we're still parsing the old line. Append the new bytes into buffer:
            buffer = concat(buffer, arr);
        }

        const bufLength = buffer.length;
        let lineStart = 0; // index where the current line starts
        while (position < bufLength) {
            if (discardTrailingNewline) {
                if (buffer[position] === ControlChars.NewLine) {
                    lineStart = ++position; // skip to next char
                }

                discardTrailingNewline = false;
            }

            // start looking forward till the end of line:
            let lineEnd = -1; // index of the \r or \n char
            for (; position < bufLength && lineEnd === -1; ++position) {
                switch (buffer[position]) {
                    case ControlChars.Colon:
                        if (fieldLength === -1) { // first colon in line
                            fieldLength = position - lineStart;
                        }
                        break;
                    // @ts-expect-error:7029 \r case below should fallthrough to \n:
                    case ControlChars.CarriageReturn:
                        discardTrailingNewline = true;
                        // fallthrough
                    case ControlChars.NewLine:
                        lineEnd = position;
                        break;
                }
            }

            if (lineEnd === -1) {
                // We reached the end of the buffer but the line hasn't ended.
                // Wait for the next arr and then continue parsing:
                break;
            }

            // we've reached the line end, send it out:
            const line = buffer.subarray(lineStart, lineEnd);
            queue.push({ line, fieldLength });
            processQueue(); // 尝试处理队列

            lineStart = position; // we're now on the next line
            fieldLength = -1;
        }

        if (lineStart === bufLength) {
            buffer = undefined; // we've finished reading it
        } else if (lineStart !== 0) {
            // Create a new view into buffer beginning at lineStart so we don't
            // need to copy over the previous lines when we get the new arr:
            buffer = buffer.subarray(lineStart);
            position -= lineStart;
        }
    }
}

/** 
 * Parses line buffers into EventSourceMessages.
 * @param onId A function that will be called on each `id` field.
 * @param onRetry A function that will be called on each `retry` field.
 * @param onMessage A function that will be called on each message.
 * @returns A function that should be called for each incoming line buffer.
 */
export function getMessages(
    onId: (id: string) => void,
    onRetry: (retry: number) => void,
    onMessage?: (msg: EventSourceMessage) => Promise<void>
) {
    let message = newMessage();
    const decoder = new TextDecoder();
    let processingMessage = false;  // 添加标志防止并发处理

    // return a function that can process each incoming line buffer:
    return async function onLine(line: Uint8Array, fieldLength: number) {
        if (line.length === 0) {
            // empty line denotes end of message. Trigger the callback and start a new message:

            if (message.data) {  // 只处理有数据的消息
                // 克隆消息对象，避免在异步处理过程中被修改
                const messageToSend = {
                    id: message.id,
                    event: message.event,
                    data: message.data,
                    retry: message.retry
                };

                if (processingMessage) {
                    console.warn("警告：上一条消息尚未处理完成就收到了新消息");
                }

                processingMessage = true;
                try {
                    await onMessage?.(messageToSend);
                } finally {
                    processingMessage = false;
                }
            }

            message = newMessage();
        } else if (fieldLength > 0) { // exclude comments and lines with no values
            // line is of format "<field>:<value>" or "<field>: <value>"
            // https://html.spec.whatwg.org/multipage/server-sent-events.html#event-stream-interpretation
            const field = decoder.decode(line.subarray(0, fieldLength));
            const valueOffset = fieldLength + (line[fieldLength + 1] === ControlChars.Space ? 2 : 1);
            const value = decoder.decode(line.subarray(valueOffset));

            switch (field) {
                case 'data':
                    // if this message already has data, append the new value to the old.
                    // otherwise, just set to the new value:
                    message.data = message.data
                        ? message.data + '\n' + value
                        : value; // otherwise, 
                    break;
                case 'event':
                    message.event = value;
                    break;
                case 'id':
                    onId(message.id = value);
                    break;
                case 'retry':
                    {
                        const retry = parseInt(value, 10);
                        if (!isNaN(retry)) { // per spec, ignore non-integers
                            onRetry(message.retry = retry);
                        }
                        break;
                    }
            }
        }
    }
}

function concat(a: Uint8Array, b: Uint8Array) {
    const res = new Uint8Array(a.length + b.length);
    res.set(a);
    res.set(b, a.length);
    return res;
}

function newMessage(): EventSourceMessage {
    // data, event, and id must be initialized to empty strings:
    // https://html.spec.whatwg.org/multipage/server-sent-events.html#event-stream-interpretation
    // retry should be initialized to undefined so we return a consistent shape
    // to the js engine all the time: https://mathiasbynens.be/notes/shapes-ics#takeaways
    return {
        data: '',
        event: '',
        id: '',
        retry: undefined,
    };
}
