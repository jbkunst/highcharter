import { SharedBufferChannelMain, SharedBufferChannelWorker } from './channel-shared';
import { PostMessageChannelMain, PostMessageChannelWorker } from './channel-postmessage';
import { WebROptions } from '../webr-main';
export declare const ChannelType: {
    readonly Automatic: 0;
    readonly SharedArrayBuffer: 1;
    readonly PostMessage: 3;
};
export type ChannelInitMessage = {
    type: string;
    data: {
        config: Required<WebROptions>;
        channelType: Exclude<(typeof ChannelType)[keyof typeof ChannelType], typeof ChannelType.Automatic>;
        clientId?: string;
        location?: string;
    };
};
export declare function newChannelMain(data: Required<WebROptions>): SharedBufferChannelMain | PostMessageChannelMain;
export declare function newChannelWorker(msg: ChannelInitMessage): SharedBufferChannelWorker | PostMessageChannelWorker;
