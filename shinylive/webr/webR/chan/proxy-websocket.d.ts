import { ChannelMain } from "./channel";
import { SharedBufferChannelWorker } from "./channel-shared";
export interface WebSocketProxy extends WebSocket {
    uuid: string;
    _accept(): void;
    _recieve(data: string | ArrayBufferLike | Blob | ArrayBufferView): void;
    _close(code?: number, reason?: string): void;
    _error(): void;
}
export declare class WebSocketMap {
    #private;
    readonly chan: ChannelMain;
    WebSocket: typeof WebSocket;
    constructor(chan: ChannelMain);
    new(uuid: string, url: string | URL, protocols?: string | string[]): void;
    send(uuid: string, data: string | ArrayBufferLike | Blob | ArrayBufferView): void;
    close(uuid: string, code?: number, reason?: string): void;
}
export declare class WebSocketProxyFactory {
    static proxy(chan: SharedBufferChannelWorker): typeof WebSocket;
}
