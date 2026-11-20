import { WebRData, RPtr } from './robj';
import { RObject, RHandle } from './robj-worker';
export declare function protect<T extends RHandle>(x: T): T;
export declare function protectInc<T extends RHandle>(x: T, prot: {
    n: number;
}): T;
export declare function protectWithIndex(x: RHandle): {
    loc: number;
    ptr: RPtr;
};
export declare function unprotectIndex(index: {
    ptr: RPtr;
}): void;
export declare function reprotect<T extends RHandle>(x: T, index: {
    loc: number;
    ptr: RPtr;
}): T;
export declare function unprotect(n: number): void;
export declare function envPoke(env: RHandle, sym: RHandle, value: RHandle): void;
export declare function parseEvalBare(code: string, env: WebRData): RObject;
export declare class UnwindProtectException extends Error {
    cont: RPtr;
    constructor(message: string, cont: RPtr);
}
export declare function safeEval(call: RHandle, env: RHandle): RPtr;
