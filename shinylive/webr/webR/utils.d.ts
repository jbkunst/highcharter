export type PromiseHandles<T = void> = {
    resolve: ResolveFn<T>;
    reject: RejectFn;
    promise: Promise<T>;
};
export type ResolveFn<T = unknown> = (value: T | PromiseLike<T>) => void;
export type RejectFn = (_reason?: any) => void;
export declare function promiseHandles<T = void>(): PromiseHandles<T>;
export declare function sleep(ms: number): Promise<unknown>;
export declare function replaceInObject<T>(obj: T | T[], test: (obj: any) => boolean, replacer: (obj: any, ...replacerArgs: any[]) => unknown, ...replacerArgs: unknown[]): T | T[];
export declare function newCrossOriginWorker(url: string, cb: (worker: Worker) => void, onError?: (error: Error) => void, options?: WorkerOptions, async?: boolean): void;
export declare function isCrossOrigin(urlString: string): boolean;
export declare function isImageBitmap(value: any): value is ImageBitmap;
export declare function throwUnreachable(context?: string): void;
export declare function isSimpleObject(value: any): value is {
    [key: string | number | symbol]: any;
};
export declare function bufferToBase64(buffer: ArrayBufferLike): string;
export declare function base64ToBuffer(base64: string): ArrayBuffer;
