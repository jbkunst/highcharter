import { Endpoint } from './task-common';
import { SyncRequestData } from './message';
/**
 * Respond to a blocking request. Most of the work has already been done in
 * asynclink, we are just responsible here for getting the return value back to
 * the requester through this slightly convoluted Atomics protocol.
 * @param {Endpoint} endpoint  A message port to receive messages from. Other
 *        thread is blocked, so we can't send messages back.
 * @param {SyncRequestData} data The message that was recieved. We will use it
 *        to read out the buffers to write the answer into. NOTE: requester
 *        owns buffers.
 * @param {any} response The value we want to send back to the requester. We
 *        have to encode it into data_buffer.
 */
export declare function syncResponse(endpoint: Endpoint, data: SyncRequestData, response: any): Promise<void>;
