import React from "react";
import "./Share.css";
export type ShareItem = {
    name: string;
    path: string;
    data?: Uint8Array;
    text?: string;
    autorun?: boolean;
};
export declare enum ShareDataFlags {
    UNCOMPRESSED = "u",
    ZLIB = "z",
    MSGPACK = "m",
    JSON = "j",
    AUTORUN = "a"
}
export declare function isShareItems(files: any): files is ShareItem[];
/**
 * Encode files for sharing.
 *
 * Encode shared files for use as the hash string in a sharing URL.
 * This function outputs strings with msgpack format and zlib compression.
 *
 * Shared item typing
 * ------------------
 * A shared item is an object with the following format,
 *
 *   { name: string; path: string; text?: string; data?: Uint8Array }
 *
 * where `name` is a display name (usually the filename), `path` is the path
 * where the file will be written to the Emscripten VFS, and either a `text`
 * string or the file's binary `data` is present, defining the content for the
 * shared file.
 *
 * Sharing via Data URI
 * --------------------
 * An array of shared items should be encoded either in msgpack or JSON format,
 * and then optionally compressed using the zlib deflate algorithm.
 *
 * The resulting binary data should be base64 encoded, with special characters
 * encoded for use as a URL hash.
 *
 * The hash may optionally end in `&[...]`, where [...] may be one or more of
 * the following flags:
 *  - 'u': uncompressed
 *  - 'z': zlib compressed
 *  - 'm': msgpack format
 *  - 'j': json format
 *  - 'a': autorun R scripts
 * The default flags string is `&mz`.
 *
 * Sharing via `postMessage()`
 * ---------------------------
 * The webR app listens for messages with `data` containing an array of shared
 * items: { items: ShareItem[] }.
 *
 * When such a message has been received, the shared file content is applied
 * to the current editor.
 * @param {ShareItem[]} items An array of shared file content.
 * @returns {string} Encoded URI string.
 */
export declare function encodeShareData(items: ShareItem[]): string;
/**
 * Decode shared files data.
 *
 * Decodes the hash string provided in a sharing URL. Data may be JSON or
 * msgpack encoded, with optional compression. See `encodeShareData()` for
 * futher details.
 * @param {string} data Encoded URI string.
 * @param {string} [flags] Decoding flags. Defaults to `mz`, meaning msgpack
 *   format and zlib compressed.
 * @returns {ShareItem[]} An array of shared file content.
 */
export declare function decodeShareData(data: string, flags?: string): ShareItem[];
interface ShareModalProps {
    isOpen: boolean;
    onClose: () => void;
    shareUrl: string;
}
export declare function ShareModal({ isOpen, onClose, shareUrl }: ShareModalProps): React.JSX.Element | null;
export default ShareModal;
