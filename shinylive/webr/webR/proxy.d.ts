/**
 * Proxy R objects on the webR worker thread so that they can be accessed from
 * the main thread.
 * @module Proxy
 */
import { ChannelMain } from './chan/channel';
import { WebRPayloadPtr } from './payload';
import { RType, RCtor } from './robj';
import * as RWorker from './robj-worker';
import { ShelterID } from './webr-chan';
/**
 * Obtain a union of the keys corresponding to methods of a given class `T`.
 * @typeParam T The type to provide the methods for.
 */
export type Methods<T> = {
    [P in keyof T]: T[P] extends (...args: any) => any ? P : never;
}[keyof T];
/**
 * Distributive conditional type for {@link RProxy}.
 *
 * Distributes {@link RProxy} over any {@link RWorker.RObject} in the given
 * union type U.
 * @typeParam U The type union to distribute {@link RProxy} over.
 */
export type DistProxy<U> = U extends RWorker.RObject ? RProxy<U> : U;
/**
 * Convert {@link RWorker.RObject} properties for use with an {@link RProxy}.
 *
 * Properties in the type parameter `T` are mapped so that {@link RProxy} is
 * distributed over any {@link RWorker.RObject} types, then wrapped in a
 * Promise.
 *
 * Function signatures are mapped so that arguments with {@link RWorker.RObject}
 * type instead take {@link RProxy}<{@link RWorker.RObject}> type. Other
 * function arguments remain as they are. The function return type is also
 * converted to a corresponding type using `RProxify` recursively.
 * @typeParam T The type to convert.
 */
export type RProxify<T> = T extends Array<any> ? Promise<DistProxy<T[0]>[]> : T extends (...args: infer U) => any ? (...args: {
    [V in keyof U]: DistProxy<U[V]>;
}) => RProxify<ReturnType<T>> : T extends {
    result: RWorker.RObject;
    output: RWorker.RObject;
} ? Promise<{
    [U in keyof T]: DistProxy<T[U]>;
}> : Promise<DistProxy<T>>;
/**
 * Create an {@link RProxy} based on an {@link RWorker.RObject} type parameter.
 *
 * R objects created via an {@link RProxy} are intended to be used in place of
 * {@link RWorker.RObject} on the main thread. An {@link RProxy} object has the
 * same instance methods as the given {@link RWorker.RObject} parameter, with
 * the following differences:
 * - Method arguments take `RProxy` in place of {@link RWorker.RObject}.
 *
 * - Where an {@link RWorker.RObject} would be returned, an `RProxy` is
 *   returned instead.
 *
 * - All return types are wrapped in a Promise.
 *
 * If required, the {@link Payload.WebRPayloadPtr} object associated with the
 * proxy can be accessed directly through the `_payload` property.
 * @typeParam T The {@link RWorker.RObject} type to convert into `RProxy` type.
 */
export type RProxy<T extends RWorker.RObject> = {
    [P in Methods<T>]: RProxify<T[P]>;
} & {
    _payload: WebRPayloadPtr;
    [Symbol.asyncIterator](): AsyncGenerator<RProxy<RWorker.RObject>, void, unknown>;
};
/**
 * Create a proxy constructor based on a {@link RWorker.RObject} class.
 *
 * The class constructors and static methods of the given subclass of
 * {@link RWorker.RObject} are proxied, and the proxied constructor returns a
 * promise to an R object of a given {@link RProxy} type.
 * @typeParam T The type of the {@link RWorker.RObject} class to be proxied.
 * @typeParam R The type to be returned from the proxied class constructor.
 */
export type ProxyConstructor<T, R> = (T extends abstract new (...args: infer U) => any ? {
    new (...args: {
        [V in keyof U]: U[V];
    }): Promise<R>;
} : never) & {
    [P in Methods<typeof RWorker.RObject>]: RProxify<(typeof RWorker.RObject)[P]>;
};
/**
 * Proxy an R object method by providing an async function that requests that
 * the worker thread calls the method and then returns the result.
 *
 * When the optional payload argument has not been provided, an
 * {@link RWorker.RObject} static method is called.
 * @internal
 */
export declare function targetMethod(chan: ChannelMain, prop: string): unknown;
export declare function targetMethod(chan: ChannelMain, prop: string, payload: WebRPayloadPtr): unknown;
/**
 * Proxy an R object.
 *
 * The proxy targets a particular R object in WebAssembly memory. Methods of the
 * relevant subclass of {@link RWorker.RObject} are proxied, enabling
 * structured manipulation of R objects from the main thread.
 * @param {ChannelMain} chan The current main thread communication channel.
 * @param {WebRPayloadPtr} payload A webR payload referencing an R object.
 * @returns {RProxy<RWorker.RObject>} An {@link RObject} corresponding to the
 * referenced R object.
 */
export declare function newRProxy(chan: ChannelMain, payload: WebRPayloadPtr): RProxy<RWorker.RObject>;
/**
 * Proxy an {@link RWorker.RObject} class.s
 * @param {ChannelMain} chan The current main thread communication channel.
 * @param {ShelterID} shelter The shelter ID to protect returned objects with.
 * @param {(RType | RCtor)} objType The R object type or class, `'object'` for
 * the generic {@link RWorker.RObject} class.
 * @returns {ProxyConstructor} A proxy to the R object subclass corresponding to
 * the given value of the `objType` argument.
 * @typeParam T The type of the {@link RWorker.RObject} class to be proxied.
 * @typeParam R The type to be returned from the proxied class constructor.
 */
export declare function newRClassProxy<T, R>(chan: ChannelMain, shelter: ShelterID, objType: RType | RCtor): ProxyConstructor<T, R>;
