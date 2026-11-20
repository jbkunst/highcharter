import { WebR, WebROptions } from './webr-main';
export interface ConsoleCallbacks {
    stdout?: (line: string) => void;
    stderr?: (line: string) => void;
    prompt?: (line: string) => void;
    canvasImage?: (image: ImageBitmap) => void;
    canvasNewPage?: () => void;
}
/**
 * Text-based Interactive Console for WebR
 *
 * A helper application to assist in creating an interactive R REPL based on
 * JavaScript callbacks.
 *
 * Callback functions ``stdout`` and ``stderr`` are called with a single line
 * of output as the first argument. The default implementation of `stdout` and
 * `stderr` writes to the console using `console.log` and `console.error`.
 *
 * R code can be sent as input by calling the ``stdin`` method with a single
 * line of textual input.
 *
 * A long running R computation can be interrupted by calling the `interrupt`
 * method.
 *
 * The ``prompt`` callback function is called when webR produces a prompt at
 * the REPL console and is therefore awaiting user input. The prompt character
 * (usually ``>`` or ``+``) is given as the first argument to the callback
 * function. The default implementation of `prompt` shows a JavaScript prompt
 * asking the user for input, and then sends the user input to `stdin`.
 *
 * The ``canvasImage`` callback function is called when webR writes plots to
 * the built-in HTML canvas graphics device.
 *
 * The ``canvasNewPage`` callback function is called when webR creates a new
 * plot.
 *
 * Once constructed, start the Console using the ``run`` method. The `run`
 * method starts an asynchronous infinite loop that waits for output from the
 * webR worker and then calls the relevant callbacks.
 */
export declare class Console {
    #private;
    /** The supporting instance of webR */
    webR: WebR;
    /**
     * A HTML canvas element
     *
     * The canvas graphics device writes to this element by default. Undefined
     * when HTML canvas is unsupported.
     */
    canvas: HTMLCanvasElement | undefined;
    /**
     * @param {ConsoleCallbacks} callbacks A list of webR Console callbacks to
     * be used for this console.
     * @param {WebROptions} options The options to use for the new instance of
     * webR started to support this console.
     */
    constructor(callbacks?: ConsoleCallbacks, options?: WebROptions);
    /**
     * Write a line of input to webR's REPL through ``stdin``
     * @param {string} input A line of input text.
     */
    stdin(input: string): void;
    /**
     * Interrupt a long running R computation and return to the prompt
     */
    interrupt(): void;
    /**
     * Start the webR console
     */
    run(): void;
}
