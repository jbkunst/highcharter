/**
 * Interfaces for the webR main and worker thread communication channels.
 * @module Channel
 */
import { AsyncQueue } from './queue';
import { EventMessage, Message, Response } from './message';
import { WebRPayload } from '../payload';
export declare abstract class ChannelMain {
    #private;
    inputQueue: AsyncQueue<Message>;
    outputQueue: AsyncQueue<Message>;
    systemQueue: AsyncQueue<Message>;
    eventQueue: EventMessage[];
    abstract initialised: Promise<unknown>;
    abstract close(): void;
    abstract emit(msg: Message): void;
    abstract interrupt(): void;
    read(): Promise<Message>;
    flush(): Promise<Message[]>;
    readSystem(): Promise<Message>;
    write(msg: Message): void;
    request(msg: Message, transferables?: [Transferable]): Promise<WebRPayload>;
    protected putClosedMessage(): void;
    protected resolveResponse(msg: Response): void;
}
export interface ChannelWorker {
    WebSocketProxy: typeof WebSocket | undefined;
    WorkerProxy: typeof Worker | undefined;
    resolve(): void;
    write(msg: Message, transfer?: [Transferable]): void;
    writeSystem(msg: Message, transfer?: [Transferable]): void;
    syncRequest(msg: Message, transfer?: [Transferable]): Message;
    read(): Message;
    handleEvents(): void;
    setInterrupt(interrupt: () => void): void;
    run(args: string[]): void;
    inputOrDispatch: () => number;
    setDispatchHandler: (dispatch: (msg: Message) => void) => void;
    resolveRequest: (msg: Message) => void;
}
/**
 * Handler functions dealing with setup and communication over a Service Worker.
 */
export interface ServiceWorkerHandlers {
    handleActivate: (this: ServiceWorkerGlobalScope, ev: ExtendableEvent) => any;
    handleFetch: (this: ServiceWorkerGlobalScope, ev: FetchEvent) => any;
    handleInstall: (this: ServiceWorkerGlobalScope, ev: ExtendableEvent) => any;
    handleMessage: (this: ServiceWorkerGlobalScope, ev: ExtendableMessageEvent) => any;
}
