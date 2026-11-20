import { Text } from '@codemirror/state';
import { EditorView } from '@codemirror/view';
export type CursorPosition = {
    line: number;
    col: number;
};
export declare function offsetToPosition(cmDoc: Text, offset: number): CursorPosition;
export declare function positionToOffset(cmDoc: Text, pos: CursorPosition): number;
export declare function getSelectedText(cmView: EditorView): string;
export declare function getCurrentLineText(cmView: EditorView): string;
export declare function moveCursorToNextLine(cmView: EditorView): void;
export declare function decodeTextOrBinaryContent(data: Uint8Array): string;
