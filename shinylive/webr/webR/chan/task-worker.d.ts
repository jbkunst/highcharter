import { Endpoint } from './task-common';
import { Message } from './message';
export declare class SyncTask {
    #private;
    endpoint: Endpoint;
    msg: Message;
    transfers: Transferable[];
    taskId?: number;
    sizeBuffer?: Int32Array;
    signalBuffer?: Int32Array;
    syncifier: _Syncifier;
    constructor(endpoint: Endpoint, msg: Message, transfers?: Transferable[]);
    scheduleSync(): this | undefined;
    poll(): boolean;
    doSync(): Generator<undefined, unknown, unknown>;
    get result(): unknown;
    syncify(): any;
}
declare class _Syncifier {
    nextTaskId: Int32Array;
    signalBuffer: Int32Array;
    tasks: Map<number, SyncTask>;
    constructor();
    scheduleTask(task: SyncTask): void;
    waitOnSignalBuffer(): void;
    tasksIdsToWakeup(): Generator<number, void, unknown>;
    pollTasks(task?: SyncTask): boolean;
    syncifyTask(task: SyncTask): void;
}
/**
 * Sets the events handler. This is called when the computation is
 * interrupted by an event. Should zero the event buffer.
 * @internal
 */
export declare function setEventsHandler(handler: () => void): void;
/**
 * Sets the events buffer. Should be a shared array buffer. When element 0
 * is set non-zero it signals an event has been emitted.
 * @internal
 */
export declare function setEventBuffer(buffer: ArrayBufferLike): void;
export {};
