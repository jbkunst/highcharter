import { Complex, NamedEntries, NamedObject, WebRDataRaw, WebRDataScalar } from './robj';
import { WebRData, WebRDataAtomic, RPtr, RType, RCtor } from './robj';
import { WebRDataJs, WebRDataJsAtomic, WebRDataJsNode } from './robj';
import { WebRDataJsNull, WebRDataJsString, WebRDataJsSymbol } from './robj';
import { EvalROptions, ShelterID } from './webr-chan';
export type RHandle = RObject | RPtr;
export declare function handlePtr(x: RHandle): RPtr;
export declare const shelters: Map<string, number[]>;
export declare function keep(shelter: ShelterID, x: RHandle): void;
export declare function destroy(shelter: ShelterID, x: RHandle): void;
export declare function purge(shelter: ShelterID): void;
export interface ToJsOptions {
    depth: number;
}
export type Nullable<T> = T | RNull;
export declare class RObjectBase {
    ptr: RPtr;
    constructor(ptr: RPtr);
    type(): RType;
}
export declare class RObject extends RObjectBase {
    #private;
    constructor(data: WebRData);
    static wrap<T extends typeof RObject>(this: T, ptr: RPtr): InstanceType<T>;
    get [Symbol.toStringTag](): string;
    /** @internal */
    static getPersistentObject(prop: keyof typeof objs): unknown;
    /** @internal */
    getPropertyValue(prop: keyof this): unknown;
    inspect(): void;
    isNull(): this is RNull;
    isNa(): boolean;
    isUnbound(): boolean;
    attrs(): Nullable<RPairlist>;
    class(): RCharacter;
    setNames(values: (string | null)[] | null): this;
    names(): (string | null)[] | null;
    includes(name: string): boolean | null;
    toJs(options?: ToJsOptions, depth?: number): WebRDataJs;
    subset(prop: number | string): RObject;
    get(prop: number | string): RObject;
    getDollar(prop: string): RObject;
    pluck(...path: (string | number)[]): RObject | undefined;
    set(prop: string | number, value: RObject | WebRDataRaw): RObject;
    /** @internal */
    static getMethods(obj: RObject): string[];
}
export declare class RNull extends RObject {
    constructor();
    toJs(): WebRDataJsNull;
}
export declare class RSymbol extends RObject {
    constructor(x: WebRDataScalar<string>);
    toJs(): WebRDataJsSymbol;
    toObject(): {
        printname: string | null;
        symvalue: RPtr | null;
        internal: RPtr | null;
    };
    toString(): string;
    printname(): RString;
    symvalue(): RObject;
    internal(): RObject;
}
export declare class RPairlist extends RObject {
    constructor(val: WebRData);
    get length(): number;
    toArray(options?: ToJsOptions): WebRData[];
    toObject({ allowDuplicateKey, allowEmptyKey, depth, }?: {
        allowDuplicateKey?: boolean | undefined;
        allowEmptyKey?: boolean | undefined;
        depth?: number | undefined;
    }): NamedObject<WebRData>;
    entries(options?: ToJsOptions): NamedEntries<WebRData>;
    toJs(options?: ToJsOptions, depth?: number): WebRDataJsNode;
    includes(name: string): boolean;
    setcar(obj: RObject): void;
    car(): RObject;
    cdr(): Nullable<RPairlist>;
    tag(): Nullable<RSymbol>;
}
export declare class RCall extends RObject {
    constructor(val: WebRData);
    setcar(obj: RObject): void;
    car(): RObject;
    cdr(): Nullable<RPairlist>;
    eval(): RObject;
    capture(options?: EvalROptions): {
        result: RObject;
        output: RList;
        images: ImageBitmap[];
    };
    deparse(): string;
}
export declare class RList extends RObject {
    constructor(val: WebRData, names?: (string | null)[] | null);
    get length(): number;
    isDataFrame(): boolean;
    toArray(options?: {
        depth: number;
    }): WebRData[];
    toObject({ allowDuplicateKey, allowEmptyKey, depth, }?: {
        allowDuplicateKey?: boolean | undefined;
        allowEmptyKey?: boolean | undefined;
        depth?: number | undefined;
    }): NamedObject<WebRData>;
    toD3(): NamedObject<WebRData>[];
    entries(options?: {
        depth: number;
    }): NamedEntries<WebRData>;
    toJs(options?: {
        depth: number;
    }, depth?: number): WebRDataJsNode;
}
export declare class RDataFrame extends RList {
    constructor(val: WebRData);
    static fromObject(obj: WebRData): RDataFrame;
    static fromD3(arr: {
        [key: string]: WebRData;
    }[]): RDataFrame;
}
export declare class RFunction extends RObject {
    exec(...args: (WebRDataRaw | RObject)[]): RObject;
    capture(options?: EvalROptions, ...args: (WebRDataRaw | RObject)[]): {
        result: RObject;
        output: RList;
        images: ImageBitmap[];
    };
}
export declare class RString extends RObject {
    static CEType: {
        readonly CE_NATIVE: 0;
        readonly CE_UTF8: 1;
        readonly CE_LATIN1: 2;
        readonly CE_BYTES: 3;
        readonly CE_SYMBOL: 5;
        readonly CE_ANY: 99;
    };
    constructor(x: WebRDataScalar<string>);
    toString(): string;
    toJs(): WebRDataJsString;
}
export declare class REnvironment extends RObject {
    constructor(val?: WebRData);
    ls(all?: boolean, sorted?: boolean): string[];
    bind(name: string, value: WebRData): void;
    names(): string[];
    frame(): RObject;
    subset(prop: number | string): RObject;
    toObject({ depth }?: {
        depth?: number | undefined;
    }): NamedObject<WebRData>;
    toJs(options?: {
        depth: number;
    }, depth?: number): WebRDataJsNode;
}
type TypedArray = Int8Array | Uint8Array | Int16Array | Uint16Array | Int32Array | Uint32Array | Float32Array | Float64Array;
export type atomicType = number | boolean | Complex | string;
declare abstract class RVectorAtomic<T extends atomicType> extends RObject {
    constructor(val: WebRDataAtomic<T>, kind: RType, newSetter: (ptr: RPtr) => (v: any, i: number) => void);
    get length(): number;
    get(prop: number | string): this;
    subset(prop: number | string): this;
    getDollar(): RObject;
    detectMissing(): boolean[];
    abstract toTypedArray(): TypedArray;
    toArray(): (T | null)[];
    toObject({ allowDuplicateKey, allowEmptyKey }?: {
        allowDuplicateKey?: boolean | undefined;
        allowEmptyKey?: boolean | undefined;
    }): NamedObject<T | null>;
    entries(): NamedEntries<T | null>;
    toJs(): WebRDataJsAtomic<T>;
}
export declare class RLogical extends RVectorAtomic<boolean> {
    #private;
    constructor(val: WebRDataAtomic<boolean>);
    getBoolean(idx: number): boolean | null;
    toBoolean(): boolean;
    toTypedArray(): Int32Array;
    toArray(): (boolean | null)[];
}
export declare class RInteger extends RVectorAtomic<number> {
    #private;
    constructor(val: WebRDataAtomic<number>);
    getNumber(idx: number): number | null;
    toNumber(): number;
    toTypedArray(): Int32Array;
}
export declare class RDouble extends RVectorAtomic<number> {
    #private;
    constructor(val: WebRDataAtomic<number>);
    getNumber(idx: number): number | null;
    toNumber(): number;
    toTypedArray(): Float64Array;
}
export declare class RComplex extends RVectorAtomic<Complex> {
    #private;
    constructor(val: WebRDataAtomic<Complex>);
    getComplex(idx: number): Complex | null;
    toComplex(): Complex;
    toTypedArray(): Float64Array;
    toArray(): (Complex | null)[];
}
export declare class RCharacter extends RVectorAtomic<string> {
    #private;
    constructor(val: WebRDataAtomic<string>);
    getString(idx: number): string | null;
    toString(): string;
    toTypedArray(): Uint32Array;
    toArray(): (string | null)[];
}
export declare class RRaw extends RVectorAtomic<number> {
    #private;
    constructor(val: WebRDataAtomic<number>);
    getNumber(idx: number): number | null;
    toNumber(): number;
    toTypedArray(): Uint8Array;
}
export declare function getRWorkerClass(type: RType | RCtor): typeof RObject;
/**
 * Test for an RWorker.RObject instance.
 *
 * RWorker.RObject is the internal interface to R objects, intended to be used
 * on the worker thread.
 *
 * @private
 * @param {any} value The object to test.
 * @return {boolean} True if the object is an instance of an RObject.
 */
export declare function isRObject(value: any): value is RObject;
/**
 * Test for an RWorker.RVectorAtomic instance.
 *
 * @private
 * @param {any} value The object to test.
 * @return {boolean} True if the object is an instance of an RVectorAtomic.
 */
export declare function isRVectorAtomic(value: any): value is RVectorAtomic<atomicType>;
/**
 * Test for an atomicType, including missing `null` values.
 *
 * @private
 * @param {any} value The object to test.
 * @return {boolean} True if the object is of type atomicType.
 */
export declare function isAtomicType(value: any): value is atomicType | null;
/**
 * A store for persistent R objects, initialised at R startup.
 */
export declare let objs: {
    baseEnv: REnvironment;
    bracket2Symbol: RSymbol;
    bracketSymbol: RSymbol;
    dollarSymbol: RSymbol;
    emptyEnv: REnvironment;
    false: RLogical;
    globalEnv: REnvironment;
    na: RLogical;
    namesSymbol: RSymbol;
    naString: RObject;
    null: RNull;
    true: RLogical;
    unboundValue: RObject;
};
/**
 * Populate the persistent R object store.
 * @internal
 */
export declare function initPersistentObjects(): void;
export {};
