import React from 'react';
import './Plot.css';
import { PlotInterface } from '../App';
import { WebR } from '../../webR/webr-main';
export declare function Plot({ webR, plotInterface, maximize, hidden, }: {
    webR: WebR;
    plotInterface: PlotInterface;
    maximize: boolean;
    hidden: boolean;
}): React.JSX.Element;
export default Plot;
