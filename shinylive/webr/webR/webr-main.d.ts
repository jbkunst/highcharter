/**
 * The webR JavaScript API.
 * @module WebR
 */
import { ChannelMain } from './chan/channel';
import { ChannelType } from './chan/channel-common';
import { Message } from './chan/message';
import { EmPtr } from './emscripten';
import { newRClassProxy } from './proxy';
import { RCharacter, RComplex, RDouble } from './robj-main';
import { REnvironment, RSymbol, RInteger, RList, RDataFrame } from './robj-main';
import { RLogical, RNull, RObject, RPairlist, RRaw, RString, RCall } from './robj-main';
import * as RWorker from './robj-worker';
import { EvalROptions, InstallPackagesOptions } from './webr-chan';
export { Console, ConsoleCallbacks } from './console';
export * from './robj-main';
export * from './error';
export * from './webr-chan';
export { ChannelType } from './chan/channel-common';
/**
 * The webR FS API for interacting with the Emscripten Virtual File System.
 */
export interface WebRFS {
    /**
     * Lookup information about a file or directory node in the Emscripten
     * virtual file system.
     * @param {string} path Path to the requested node.
     * @returns {Promise<FSNode>} The requested node.
     */
    lookupPath: (path: string) => Promise<FSNode>;
    /**
     * Create a directory on the Emscripten virtual file system.
     * @param {string} path Path of the directory to create.
     * @returns {Promise<FSNode>} The newly created directory node.
     */
    mkdir: (path: string) => Promise<FSNode>;
    /**
     * Get the content of a file on the Emscripten virtual file system.
     * @param {string} path Path of the file to read.
     * @param {string} [flags] Open the file with the specified flags.
     * @returns {Promise<Uint8Array>} The content of the requested file.
     */
    readFile: (path: string, flags?: string) => Promise<Uint8Array>;
    /**
     * Remove a directory on the Emscripten virtual file system.
     * @param {string} path Path of the directory to remove.
     */
    rmdir: (path: string) => Promise<void>;
    /**
     * Write a new file to the Emscripten virtual file system.
     * @param {string} path Path of the new file.
     * @param {Uint8Array} data The content of the new file.
     * @param {string} [flags] Open the file with the specified flags.
     */
    writeFile: (path: string, data: ArrayBufferView, flags?: string) => Promise<void>;
    /**
     * Unlink a node on the Emscripten virtual file system. If that node was the
     * last link to a file it is is deleted.
     * @param {string} path Path of the target node.
     */
    unlink: (path: string) => Promise<void>;
}
/** A filesystem entry in the Emscripten Virtual File System */
export type FSNode = {
    id: number;
    name: string;
    mode: number;
    isFolder: boolean;
    contents?: {
        [key: string]: FSNode;
    };
    mounted: null | {
        mountpoint: string;
        root: FSNode;
    };
};
/** An Emscripten Filesystem type */
export type FSType = 'NODEFS' | 'WORKERFS' | 'IDBFS' | 'DRIVEFS';
/**
 * Configuration settings to be used when mounting Filesystem objects with
 * Emscripten
 */
export type FSMountOptions<T extends FSType = FSType> = T extends 'DRIVEFS' ? {
    driveName?: string;
    browsingContextId?: string;
} : T extends 'NODEFS' ? {
    root: string;
} : {
    blobs?: Array<{
        name: string;
        data: Blob | Buffer | ArrayBufferLike | Uint8Array;
    }>;
    files?: Array<File | FileList>;
    packages?: Array<{
        metadata: FSMetaData;
        blob: Blob | Buffer | ArrayBufferLike | Uint8Array;
    }>;
};
/**
 * Emscripten filesystem image metadata
 */
export type FSMetaData = {
    files: {
        filename: string;
        start: number;
        end: number;
    }[];
    gzip?: boolean;
};
/** Emscripten filesystem entry information, as given by `FS.analyzePath()` */
export type FSAnalyzeInfo = {
    isRoot: boolean;
    exists: boolean;
    error: Error;
    name: string;
    path: string;
    object?: FSNode;
    parentExists: boolean;
    parentPath: string;
    parentObject?: FSNode;
};
/**
 * The configuration settings to be used when starting webR.
 */
export interface WebROptions {
    /**
     * Command line arguments to be passed to R.
     * Default: `[]`.
     */
    RArgs?: string[];
    /**
     * Environment variables to be made available for the R process.
     * Default: `{ R_HOME: '/usr/lib/R', R_ENABLE_JIT: 0 }`.
     */
    REnv?: {
        [key: string]: string;
    };
    /**
     * The base URL used for downloading R WebAssembly binaries.
     *  Default: `'https://webr.r-wasm.org/[version]/'`
     */
    baseUrl?: string;
    /**
     * The repo URL to use when downloading R WebAssembly packages.
     * Default: `'https://repo.r-wasm.org/`
     */
    repoUrl?: string;
    /**
     * The base URL from where to load JavaScript worker scripts when loading
     * webR with the ServiceWorker communication channel mode.
     * Default: `''`
     */
    serviceWorkerUrl?: string;
    /**
     * The WebAssembly user's home directory and initial working directory.
     * Default: `'/home/web_user'`
     */
    homedir?: string;
    /**
     * Start R in interactive mode?
     * Default: `true`.
     */
    interactive?: boolean;
    /**
     * Set the communication channel type to be used.
     * Default: `channelType.Automatic`
     */
    channelType?: (typeof ChannelType)[keyof typeof ChannelType];
    /**
     * Create the lazy virtual filesystem entries before starting R?
     * Default: `true`.
     */
    createLazyFilesystem?: boolean;
}
/**
 * The webR class is used to initialize and interact with the webR system.
 *
 * Start webR by constructing an instance of the WebR class, optionally passing
 * an options argument of type {@link WebROptions}. WebR will begin to download
 * and start a version of R built for WebAssembly in a worker thread.
 */
export declare class WebR {
    #private;
    globalShelter: Shelter;
    version: string;
    versionR: string;
    RObject: ReturnType<typeof newRClassProxy<typeof RWorker.RObject, RObject>>;
    RLogical: ReturnType<typeof newRClassProxy<typeof RWorker.RLogical, RLogical>>;
    RInteger: ReturnType<typeof newRClassProxy<typeof RWorker.RInteger, RInteger>>;
    RDouble: ReturnType<typeof newRClassProxy<typeof RWorker.RDouble, RDouble>>;
    RCharacter: ReturnType<typeof newRClassProxy<typeof RWorker.RCharacter, RCharacter>>;
    RComplex: ReturnType<typeof newRClassProxy<typeof RWorker.RComplex, RComplex>>;
    RRaw: ReturnType<typeof newRClassProxy<typeof RWorker.RRaw, RRaw>>;
    RList: ReturnType<typeof newRClassProxy<typeof RWorker.RList, RList>>;
    RDataFrame: ReturnType<typeof newRClassProxy<typeof RWorker.RDataFrame, RDataFrame>>;
    RPairlist: ReturnType<typeof newRClassProxy<typeof RWorker.RPairlist, RPairlist>>;
    REnvironment: ReturnType<typeof newRClassProxy<typeof RWorker.REnvironment, REnvironment>>;
    RSymbol: ReturnType<typeof newRClassProxy<typeof RWorker.RSymbol, RSymbol>>;
    RString: ReturnType<typeof newRClassProxy<typeof RWorker.RString, RString>>;
    RCall: ReturnType<typeof newRClassProxy<typeof RWorker.RCall, RCall>>;
    objs: {
        baseEnv: REnvironment;
        globalEnv: REnvironment;
        null: RNull;
        true: RLogical;
        false: RLogical;
        na: RLogical;
    };
    Shelter: new () => Promise<Shelter>;
    constructor(options?: WebROptions);
    /**
     * @returns {Promise<void>} A promise that resolves once webR has been
     * initialised.
     */
    init(): Promise<unknown>;
    /**
     * Close the communication channel between the main thread and the worker
     * thread cleanly. Once this has been executed, webR will be unable to
     * continue.
     */
    close(): void;
    /**
     * Read from the communication channel and return an output message.
     * @returns {Promise<Message>} The output message
     */
    read(): Promise<Message>;
    /**
     * Stream output messages from the communication channel via an async generator.
     * @yields {Promise<Message>} Output messages from the communication channel.
     */
    stream(): AsyncGenerator<Message, void>;
    /**
     * Flush the output queue in the communication channel and return all output
     * messages.
     * @returns {Promise<Message[]>} The output messages
     */
    flush(): Promise<Message[]>;
    /**
     * Send a message to the communication channel input queue.
     * @param {Message} msg Message to be added to the input queue.
     */
    write(msg: Message): void;
    /**
     * Send a line of standard input to the communication channel input queue.
     * @param {string} input Message to be added to the input queue.
     */
    writeConsole(input: string): void;
    /** Attempt to interrupt a running R computation. */
    interrupt(): void;
    /**
     * Install a list of R packages from Wasm binary package repositories.
     * @param {string | string[]} packages An string or array of strings
     *   containing R package names.
     * @param {InstallPackagesOptions} [options] Options to be used when
     *   installing webR packages.
     */
    installPackages(packages: string | string[], options?: InstallPackagesOptions): Promise<void>;
    /**
     * Destroy an R object reference.
     * @param {RObject} x An R object reference.
     */
    destroy(x: RObject): Promise<void>;
    /**
     * Evaluate the given R code.
     *
     * Stream outputs and any conditions raised during execution are written to
     * the JavaScript console.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<RObject>} The result of the computation.
     */
    evalR(code: string, options?: EvalROptions): Promise<RObject>;
    /**
     * Evaluate the given R code, returning a promise for no return data.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<void>} A promise which fires when the R code completes, but returns no data.
     */
    evalRVoid(code: string, options?: EvalROptions): Promise<void>;
    /**
     * Evaluate the given R code, returning a promise for a boolean value. If the returned R value is not a boolean, an error will be thrown.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<boolean>} The result of the computation.
     */
    evalRBoolean(code: string, options?: EvalROptions): Promise<boolean>;
    /**
     * Evaluate the given R code, returning a promise for a number. If the returned R value is not a number, an error will be thrown.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<number>} The result of the computation.
     */
    evalRNumber(code: string, options?: EvalROptions): Promise<number>;
    /**
     * Evaluate the given R code, returning a promise for a string. If the returned R value is not a string, an error will be thrown.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<string>} The result of the computation.
     */
    evalRString(code: string, options?: EvalROptions): Promise<string>;
    /**
     * Evaluate the given R code, returning the result as a raw JavaScript object.
     * @param {string} code The R code to evaluate.
     * @param {EvalRMessageOutputType} outputType JavaScript type to return the result as.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<unknown>} The result of the computation.
     */
    evalRRaw(code: string, outputType: 'void', options?: EvalROptions): Promise<void>;
    evalRRaw(code: string, outputType: 'boolean', options?: EvalROptions): Promise<boolean>;
    evalRRaw(code: string, outputType: 'boolean[]', options?: EvalROptions): Promise<boolean[]>;
    evalRRaw(code: string, outputType: 'number', options?: EvalROptions): Promise<number>;
    evalRRaw(code: string, outputType: 'number[]', options?: EvalROptions): Promise<number[]>;
    evalRRaw(code: string, outputType: 'string', options?: EvalROptions): Promise<string>;
    evalRRaw(code: string, outputType: 'string[]', options?: EvalROptions): Promise<string[]>;
    invokeWasmFunction(ptr: EmPtr, ...args: number[]): Promise<EmPtr>;
    FS: {
        analyzePath: (path: string, dontResolveLastLink?: boolean) => Promise<FSAnalyzeInfo>;
        lookupPath: (path: string) => Promise<FSNode>;
        mkdir: (path: string) => Promise<FSNode>;
        mount: <T extends FSType>(type: T, options: FSMountOptions<T>, mountpoint: string) => Promise<void>;
        syncfs: (populate: boolean) => Promise<void>;
        readFile: (path: string, flags?: string) => Promise<Uint8Array>;
        rename: (oldpath: string, newpath: string) => Promise<void>;
        rmdir: (path: string) => Promise<void>;
        writeFile: (path: string, data: ArrayBufferView, flags?: string) => Promise<void>;
        unlink: (path: string) => Promise<void>;
        unmount: (mountpoint: string) => Promise<void>;
    };
}
/** WebR shelters provide fine-grained control over the lifetime of R objects. */
export declare class Shelter {
    #private;
    RObject: ReturnType<typeof newRClassProxy<typeof RWorker.RObject, RObject>>;
    RLogical: ReturnType<typeof newRClassProxy<typeof RWorker.RLogical, RLogical>>;
    RInteger: ReturnType<typeof newRClassProxy<typeof RWorker.RInteger, RInteger>>;
    RDouble: ReturnType<typeof newRClassProxy<typeof RWorker.RDouble, RDouble>>;
    RCharacter: ReturnType<typeof newRClassProxy<typeof RWorker.RCharacter, RCharacter>>;
    RComplex: ReturnType<typeof newRClassProxy<typeof RWorker.RComplex, RComplex>>;
    RRaw: ReturnType<typeof newRClassProxy<typeof RWorker.RRaw, RRaw>>;
    RList: ReturnType<typeof newRClassProxy<typeof RWorker.RList, RList>>;
    RDataFrame: ReturnType<typeof newRClassProxy<typeof RWorker.RDataFrame, RDataFrame>>;
    RPairlist: ReturnType<typeof newRClassProxy<typeof RWorker.RPairlist, RPairlist>>;
    REnvironment: ReturnType<typeof newRClassProxy<typeof RWorker.REnvironment, REnvironment>>;
    RSymbol: ReturnType<typeof newRClassProxy<typeof RWorker.RSymbol, RSymbol>>;
    RString: ReturnType<typeof newRClassProxy<typeof RWorker.RString, RString>>;
    RCall: ReturnType<typeof newRClassProxy<typeof RWorker.RCall, RCall>>;
    /** @internal */
    constructor(chan: ChannelMain);
    /** @internal */
    init(): Promise<void>;
    purge(): Promise<void>;
    destroy(x: RObject): Promise<void>;
    size(): Promise<number>;
    /**
     * Evaluate the given R code.
     *
     * Stream outputs and any conditions raised during execution are written to
     * the JavaScript console. The returned R object is protected by the shelter.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<RObject>} The result of the computation.
     */
    evalR(code: string, options?: EvalROptions): Promise<RObject>;
    /**
     * Evaluate the given R code, capturing output.
     *
     * Stream outputs and conditions raised during execution are captured and
     * returned as part of the output of this function. Returned R objects are
     * protected by the shelter.
     * @param {string} code The R code to evaluate.
     * @param {EvalROptions} [options] Options for the execution environment.
     * @returns {Promise<{
     *   result: RObject,
     *   output: { type: string; data: any }[],
     *   images: ImageBitmap[]
     * }>} An object containing the result of the computation, an array of output,
     *   and an array of captured plots.
     */
    captureR(code: string, options?: EvalROptions): Promise<{
        result: RObject;
        output: {
            type: string;
            data: any;
        }[];
        images: ImageBitmap[];
    }>;
}
