export declare const SZ_BUF_DOESNT_FIT = 0;
export declare const SZ_BUF_FITS_IDX = 1;
export declare const SZ_BUF_SIZE_IDX = 0;
export interface Endpoint extends EventSource {
    postMessage(message: any, transfer?: Transferable[]): void;
    start?: () => void;
}
export interface EventSource {
    addEventListener(type: string, listener: EventListenerOrEventListenerObject, options?: object): void;
    removeEventListener(type: string, listener: EventListenerOrEventListenerObject, options?: object): void;
}
export declare function toWireValue(value: any): [any, Transferable[]];
export declare function transfer<T>(obj: T, transfers: Transferable[]): T;
export type UUID = string;
export declare function isUUID(x: any): x is UUID;
export declare const UUID_LENGTH = 63;
export declare function generateUUID(): UUID;
