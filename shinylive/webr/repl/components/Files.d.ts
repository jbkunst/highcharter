import React from "react";
import { WebR } from "../../webR/webr-main";
import type { FSNode } from "../../webR/webr-main";
import { FilesInterface } from "../App";
import "./Files.css";
interface ITreeNode {
    id: number;
    name: string;
    children?: ITreeNode[];
    metadata?: {
        [x: string]: string | number | null | undefined;
    };
}
export declare function createTreeFromFSNode(fsNode: FSNode): ITreeNode;
export declare function Files({ webR, filesInterface, hidden, }: {
    webR: WebR;
    filesInterface: FilesInterface;
    hidden: boolean;
}): React.JSX.Element;
export default Files;
