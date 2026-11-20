import { ChannelMain } from "./channel";
import { SharedBufferChannelWorker } from "./channel-shared";
import { PostMessageWorkerMessage } from "./message";
export interface WorkerProxy extends Worker {
    uuid: string;
    _message(data: any): void;
    _messageerror(data: any): void;
    _error(): void;
}
export declare class WorkerMap {
    #private;
    readonly chan: ChannelMain;
    constructor(chan: ChannelMain);
    new(uuid: string, url: string, options?: WorkerOptions): void;
    postMessage(message: PostMessageWorkerMessage): void;
    terminate(uuid: string): void;
}
export declare class WorkerProxyFactory {
    static proxy(chan: SharedBufferChannelWorker): typeof Worker;
}
