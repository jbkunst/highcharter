/**
 * Custom Error classes that shall be raised by webR.
 * @module Error
 */
/**
 * A general error raised by webR.
 */
export declare class WebRError extends Error {
    constructor(msg: string);
}
/**
 * Exceptions raised on the webR worker thread that have been forwarded to the
 * main thread through the communication channel.
 */
export declare class WebRWorkerError extends WebRError {
}
/**
 * Exceptions related to issues with the webR communication channel.
 */
export declare class WebRChannelError extends WebRError {
}
/**
 * Exceptions related to issues with webR object payloads.
 */
export declare class WebRPayloadError extends WebRError {
}
