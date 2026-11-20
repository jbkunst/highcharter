import { Readline } from "xterm-readline";
import "./App.css";
import { NamedObject, WebRDataJsAtomic } from "../webR/robj";
export interface TerminalInterface {
    println: Readline["println"];
    read: Readline["read"];
    write: Readline["write"];
}
export interface FilesInterface {
    refreshFilesystem: () => Promise<void>;
    openFilesInEditor: (openFiles: {
        name: string;
        path: string;
        readOnly?: boolean;
        forceRead?: boolean;
        execute?: boolean;
    }[], replace?: boolean) => Promise<void>;
    openContentInEditor: (openFiles: {
        name: string;
        content: Uint8Array;
    }[], replace?: boolean) => void;
    openDataInEditor: (title: string, data: NamedObject<WebRDataJsAtomic<string>>) => void;
    openHtmlInEditor: (src: string, path: string) => void;
}
export interface PlotInterface {
    resize: (direction: "width" | "height", px: number) => void;
    newPlot: () => void;
    drawImage: (img: ImageBitmap) => void;
}
