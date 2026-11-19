function fig = PlotFitnessViolins(rawMatPath, outputFigPath)
% PlotFitnessViolins  Compute SI, HSC+, FSC, and HSC- fitness distributions
% from a saved simulation .mat file using fitnessAprox.m and render a
% violin plot matching Fitness_Y_Low / Fitness_Y_High.
%
% Usage:
%   PlotFitnessViolins('RawResults/newFolder1/currItter 1 with value 2.mat', ...
%                      'PaperResults/Fitness_Y_Low.fig');
%   PlotFitnessViolins('RawResults/newFolder1/currItter 1 with value 6.mat', ...
%                      'PaperResults/Fitness_Y_High.fig');

    S = load(rawMatPath, 'popPara', 'miscPara', 'flowPop');
    [~, ~, fitSI, fitFSC, fitHSCP, fitHSCN] = ...
        fitnessAprox(S.popPara, S.miscPara, S.flowPop);

    dataCell = {gather(fitSI(:)), gather(fitHSCP(:)), ...
                gather(fitFSC(:)), gather(fitHSCN(:))};

    fig = figure('Color', 'w');
    violin(dataCell, 'xlabel', {'SI', 'HSC+', 'FSC', 'HSC-'}, ...
           'mc', [], 'medc', 'r');
    ylabel('Fitness');
    ylim([0.4 1.2]);
    ChangeFigure2Format(fig);

    if nargin >= 2 && ~isempty(outputFigPath)
        [outDir, baseName, ~] = fileparts(outputFigPath);
        if ~isempty(outDir) && ~exist(outDir, 'dir')
            mkdir(outDir);
        end
        savefig(fig, fullfile(outDir, [baseName '.fig']));
        exportgraphics(fig, fullfile(outDir, [baseName '.pdf']), 'ContentType', 'vector');
    end
end

