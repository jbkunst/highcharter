import { Message } from './message';
import { ChannelMain, ChannelWorker } from './channel';
import { WebROptions } from '../webr-main';
export declare class SharedBufferChannelMain extends ChannelMain {
    #private;
    initialised: Promise<unknown>;
    resolve: (_?: unknown) => void;
    reject: (message: string | Error) => void;
    close: () => void;
    constructor(config: Required<WebROptions>);
    emit(msg: Message): void;
    interrupt(): void;
}
import { WebSocketProxy } from './proxy-websocket';
import { WorkerProxy } from './proxy-worker';
export declare class SharedBufferChannelWorker implements ChannelWorker {
    #private;
    WebSocketProxy: typeof WebSocket;
    WorkerProxy: typeof Worker;
    ws: Map<string, WebSocketProxy>;
    workers: Map<string, WorkerProxy>;
    resolveRequest: (msg: Message) => void;
    constructor();
    resolve(): void;
    write(msg: Message, transfer?: Transferable[]): void;
    writeSystem(msg: Message, transfer?: Transferable[]): void;
    syncRequest(msg: Message, transfer?: Transferable[]): Message;
    read(): Message;
    inputOrDispatch(): number;
    run(args: string[]): void;
    handleEvents(): void;
    setInterrupt(interrupt: () => void): void;
    setDispatchHandler(dispatch: (msg: Message) => void): void;
}
