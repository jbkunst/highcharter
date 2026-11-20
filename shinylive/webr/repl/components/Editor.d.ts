import React from 'react';
import { WebR } from '../../webR/webr-main';
import { EditorState } from '@codemirror/state';
import { FilesInterface, TerminalInterface } from '../App';
import 'react-data-grid/lib/styles.css';
import './Editor.css';
type EditorBase = {
    name: string;
    readOnly: boolean;
};
export type EditorData = EditorBase & {
    type: "data";
    data: {
        columns: {
            key: string;
            name: string;
        }[];
        rows: {
            [key: string]: string;
        }[];
    };
};
export type EditorHtml = EditorBase & {
    path: string;
    type: "html";
    readOnly: boolean;
    frame: HTMLIFrameElement;
};
export type EditorFile = EditorBase & {
    path: string;
    type: "text";
    readOnly: boolean;
    dirty: boolean;
    editorState: EditorState;
    scrollTop?: number;
    scrollLeft?: number;
};
export type EditorItem = EditorData | EditorHtml | EditorFile;
export declare function FileTabs({ files, activeFileIdx, setActiveFileIdx, focusEditor, closeFile, }: {
    files: EditorItem[];
    activeFileIdx: number;
    setActiveFileIdx: React.Dispatch<React.SetStateAction<number>>;
    focusEditor: () => void;
    closeFile: (e: React.SyntheticEvent, index: number) => void;
}): React.JSX.Element;
export declare function Editor({ webR, terminalInterface, filesInterface, hidden, }: {
    webR: WebR;
    terminalInterface: TerminalInterface;
    filesInterface: FilesInterface;
    hidden: boolean;
}): React.JSX.Element;
export default Editor;
