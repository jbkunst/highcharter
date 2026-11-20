/**
 * Types containing references to R objects, raw data or errors over the webR
 * communication channel.
 * @module Payload
 */
import { WebRDataRaw, RPtr, RType } from './robj';
export type WebRPayloadRaw = {
    obj: WebRDataRaw;
    payloadType: 'raw';
};
export type WebRPayloadPtr = {
    obj: {
        type?: RType;
        ptr: RPtr;
        methods?: string[];
    };
    payloadType: 'ptr';
};
export type WebRPayloadErr = {
    obj: {
        message: string;
        name: string;
        errno?: number;
        stack?: string;
    };
    payloadType: 'err';
};
export type WebRPayload = WebRPayloadRaw | WebRPayloadPtr;
export type WebRPayloadWorker = WebRPayloadRaw | WebRPayloadPtr | WebRPayloadErr;
export declare function webRPayloadAsError(payload: WebRPayloadErr): Error;
/**
 * Test for an WebRPayload instance.
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an WebRPayload.
 */
export declare function isWebRPayload(value: any): value is WebRPayload;
/**
 * Test for an WebRPayloadPtr instance.
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an WebRPayloadPtr.
 */
export declare function isWebRPayloadPtr(value: any): value is WebRPayloadPtr;
/**
 * Test for an WebRPayloadRaw instance.
 * @param {any} value The object to test.
 * @returns {boolean} True if the object is an instance of an WebRPayloadRaw.
 */
export declare function isWebRPayloadRaw(value: any): value is WebRPayloadRaw;
