function fixFigureFonts(figHandle)
% fixFigureFonts Change all figure/subfigure fonts back to MATLAB default,
% while preserving LaTeX interpreters where they are already used.
%
% Usage:
%   fixFigureFonts(gcf)
%   fixFigureFonts(figure(1))

    if nargin < 1
        figHandle = gcf;
    end

    defaultFont = get(groot, 'defaultAxesFontName');

    defaultFont = 'Times New Roman' ;
    
    % Fix all axes, including subplots/tiled layouts
    axList = findall(figHandle, 'Type', 'axes');

    for ax = axList'
        ax.FontName = defaultFont;

        % Axis labels/title
        fixTextObject(ax.XLabel, defaultFont);
        fixTextObject(ax.YLabel, defaultFont);
        fixTextObject(ax.ZLabel, defaultFont);
        fixTextObject(ax.Title,  defaultFont);
        ax.XLabel.FontWeight ='bold' ;
        ax.YLabel.FontWeight ='bold' ;
        % Tick labels keep normal MATLAB font
        ax.TickLabelInterpreter = 'tex';
    end

    % Fix legends
    legends = findall(figHandle, 'Type', 'legend');
    for lgd = legends'
        lgd.FontName = defaultFont;
        % Do NOT overwrite interpreter, so LaTeX still works if already set
    end

    % Fix colorbars
    cbs = findall(figHandle, 'Type', 'colorbar');
    for cb = cbs'
        cb.FontName = defaultFont;
        cb.TickLabelInterpreter = 'tex';
        fixTextObject(cb.Label, defaultFont);
    end

    % Fix standalone text annotations
    txtList = findall(figHandle, 'Type', 'text');
    for txt = txtList'
        fixTextObject(txt, defaultFont);
    end
end

function fixTextObject(txtObj, defaultFont)
    if isempty(txtObj) || ~isvalid(txtObj)
        return;
    end

    txtObj.FontName = defaultFont;

    % Important:
    % Do NOT change txtObj.Interpreter.
    % So labels that already use 'latex' stay latex.
end