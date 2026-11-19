function fixAxisLabelsFontAndSave(figName)
% fixAxisLabelsFontAndSave
% Opens a MATLAB .fig file, changes ONLY axes label interpreters to 'tex',
% removes $ signs from those labels, sets their font to Times New Roman,
% and saves edited figure as .fig and .pdf in a new folder.
%
% Usage:
%   fixAxisLabelsFontAndSave('myFigure.fig')
%   fixAxisLabelsFontAndSave('myFigure')

    % ---------- input handling ----------
    if ~endsWith(figName, '.fig')
        figFile = figName + '.fig';
    else
        figFile = figName;
    end

    if ~exist(figFile)
        error('File not found: %s', figFile);
    end

    [figPath, baseName, ~] = fileparts(figFile);

    if figPath == ""
        figPath = pwd;
    end

    outputFolder = fullfile(figPath, 'edited_figures_ariel');

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    % ---------- open figure invisibly ----------
    fig = openfig(figFile, 'visible');

    % ---------- find axes only ----------
    axesList = findall(fig, 'Type', 'axes');

    for ax = axesList'

        % Change ONLY axis labels
        fixAxisLabel(ax.XLabel);
        fixAxisLabel(ax.YLabel);
        fixAxisLabel(ax.ZLabel);

        % Optional but recommended: make axis numbers match too
        ax.FontName = 'Arial';
    end

    % ---------- save edited versions ----------
    outFig = fullfile(char(outputFolder), [char(baseName) '.fig']);
    outPdf = fullfile(char(outputFolder), [char(baseName) '.pdf']);

    savefig(fig, outFig);

    print(fig, outPdf, '-dpdf', '-painters');

    close(fig);

    fprintf('Saved edited figure:\n%s\n%s\n', outFig, outPdf);
end


function fixAxisLabel(labelObj)

    if isempty(labelObj) || ~isvalid(labelObj)
        return;
    end

    % Change interpreter ONLY for axis labels
    labelObj.Interpreter = 'tex';

    % Change font
    labelObj.FontName = 'Arial';

    % Remove redundant dollar signs
    labelText = labelObj.String;

    if ischar(labelText) || isstring(labelText)
        labelObj.String = erase(labelText, '$');

    elseif iscell(labelText)
        labelObj.String = cellfun(@(s) erase(s, '$'), ...
                                  labelText, ...
                                  'UniformOutput', false);
    end
end
