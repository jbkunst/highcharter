/**
 * @module Queue
 */
/**
 * Asynchronous queue mechanism to be used by the communication channels.
 * @typeParam T The type of item to be stored in the queue.
 */
export declare class AsyncQueue<T> {
    #private;
    constructor();
    reset(): void;
    put(t: T): void;
    get(): Promise<T>;
    isEmpty(): boolean;
    isBlocked(): boolean;
    get length(): number;
}
