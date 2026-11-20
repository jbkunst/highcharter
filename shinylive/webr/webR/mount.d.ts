/**
 * Internal virtual filesystem image mounting functionality.
 * @module Mount
 */
import type { FSMountOptions } from './webr-main';
/**
 * Hooked FS.mount() for using WORKERFS under Node.js or with `Blob` objects
 * replaced with Uint8Array over the communication channel.
 * @internal
 */
export declare function mountFS(type: Emscripten.FileSystemType, opts: FSMountOptions, mountpoint: string): void;
/**
 * Mount a Jupyterlite DriveFS Emscripten filesystem to the VFS
 * @internal
 */
export declare function mountDriveFS(mountpoint: string, options: FSMountOptions<'DRIVEFS'>): void;
/**
 * Download an Emscripten FS image and mount to the VFS
 * @internal
 */
export declare function mountImageUrl(url: string, mountpoint: string): void;
/**
 * Read an Emscripten FS image from disk and mount to the VFS (requires Node)
 * @internal
 */
export declare function mountImagePath(path: string, mountpoint: string): void;
