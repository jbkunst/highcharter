import React from 'react';
import './Terminal.css';
import { TerminalInterface } from '../App';
import { WebR } from '../../webR/webr-main';
import '@xterm/xterm/css/xterm.css';
export declare function Terminal({ webR, terminalInterface, hidden, }: {
    webR: WebR;
    terminalInterface: TerminalInterface;
    hidden: boolean;
}): React.JSX.Element;
export default Terminal;
