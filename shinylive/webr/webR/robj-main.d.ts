/**
 * Module for working with R objects on the main thead through
 * JavaScript proxies. The `RObject` types in `RMain` are aliases for
 * proxies to the corresponding types in `RWorker`. For instance,
 * `RMain.RCharacter` is an alias for `RMain.RProxy<RWorker.RCharacter>`.
 * The proxies automatically and asynchronously forward method and
 * getter calls to the implementations on the R worker side.
 * @module RMain
 */
import type { RProxy } from './proxy';
import * as RWorker from './robj-worker';
export type RObject = RProxy<RWorker.RObject>;
export type RNull = RProxy<RWorker.RNull>;
export type RSymbol = RProxy<RWorker.RSymbol>;
export type RPairlist = RProxy<RWorker.RPairlist>;
export type REnvironment = RProxy<RWorker.REnvironment>;
export type RString = RProxy<RWorker.RString>;
export type RLogical = RProxy<RWorker.RLogical>;
export type RInteger = RProxy<RWorker.RInteger>;
export type RDouble = RProxy<RWorker.RDouble>;
export type RComplex = RProxy<RWorker.RComplex>;
export type RCharacter = RProxy<RWorker.RCharacter>;
export type RList = RProxy<RWorker.RList>;
export type RDataFrame = RProxy<RWorker.RDataFrame>;
export type RRaw = RProxy<RWorker.RRaw>;
export type RCall = RProxy<RWorker.RCall>;
export type RFunction = RProxy<RWorker.RFunction> & ((...args: unknown[]) => Promise<unknown>);
/**
 * Test for an RObject instance
 *
 * RObject is the user facing interface to R objects.
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RObject.
 */
export declare function isRObject(value: any): value is RObject;
/**
 * Test for an RNull instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RNull.
 */
export declare function isRNull(value: any): value is RNull;
/**
 * Test for an RSymbol instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RSymbol.
 */
export declare function isRSymbol(value: any): value is RSymbol;
/**
 * Test for an RPairlist instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RPairlist.
 */
export declare function isRPairlist(value: any): value is RPairlist;
/**
 * Test for an REnvironment instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an REnvironment.
 */
export declare function isREnvironment(value: any): value is REnvironment;
/**
 * Test for an RLogical instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RLogical.
 */
export declare function isRLogical(value: any): value is RLogical;
/**
 * Test for an RInteger instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RInteger.
 */
export declare function isRInteger(value: any): value is RInteger;
/**
 * Test for an RDouble instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RDouble.
 */
export declare function isRDouble(value: any): value is RDouble;
/**
 * Test for an RComplex instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RComplex.
 */
export declare function isRComplex(value: any): value is RComplex;
/**
 * Test for an RCharacter instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RCharacter.
 */
export declare function isRCharacter(value: any): value is RCharacter;
/**
 * Test for an RList instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RList.
 */
export declare function isRList(value: any): value is RList;
/**
 * Test for an RRaw instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RRaw.
 */
export declare function isRRaw(value: any): value is RRaw;
/**
 * Test for an RCall instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RCall.
 */
export declare function isRCall(value: any): value is RCall;
/**
 * Test for an RFunction instance
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an RFunction.
 */
export declare function isRFunction(value: any): value is RFunction;
