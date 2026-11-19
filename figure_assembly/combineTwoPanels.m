function newFig = combineTwoPanels(fig1_path, fig2_path, outputBasePath, panelLabels)
% combineTwoPanels  Parameterized 1x2 combiner implementing FigureCombiner.m.
% Combines two saved .fig files side-by-side and saves .fig and vector .pdf.

    if nargin < 4 || isempty(panelLabels)
        panelLabels = {'A', 'B'};
    end

    totalWidth_cm   = 17.8;
    marginLeft_cm   = 0.9;
    marginRight_cm  = 0.4;
    marginBottom_cm = 1.2;
    marginTop_cm    = 0.9;
    gap_cm          = 1.0;

    usableWidth_cm = totalWidth_cm - marginLeft_cm - marginRight_cm - gap_cm;
    axWidth_cm     = usableWidth_cm / 2;
    axHeight_cm    = axWidth_cm * 0.61;
    totalHeight_cm = marginBottom_cm + marginTop_cm + axHeight_cm;

    f1 = openfig(fig1_path, 'invisible');
    f2 = openfig(fig2_path, 'invisible');

    ax1_all = findall(f1, 'type', 'axes');
    ax2_all = findall(f2, 'type', 'axes');

    leg1 = findall(f1, 'Type', 'Legend');
    leg2 = findall(f2, 'Type', 'Legend');

    ax1_all = ax1_all(~strcmp(get(ax1_all, 'Tag'), 'legend') & ...
                      ~strcmp(get(ax1_all, 'Tag'), 'Colorbar'));
    ax2_all = ax2_all(~strcmp(get(ax2_all, 'Tag'), 'legend') & ...
                      ~strcmp(get(ax2_all, 'Tag'), 'Colorbar'));

    ax1_old = ax1_all(1);
    ax2_old = ax2_all(1);

    newFig = figure('Color', 'w', 'Units', 'centimeters');
    newFig.Position = [2 2 totalWidth_cm totalHeight_cm];
    newFig.PaperUnits = 'centimeters';
    newFig.PaperSize = [totalWidth_cm totalHeight_cm];
    newFig.PaperPosition = [0 0 totalWidth_cm totalHeight_cm];

    ax1_pos = [marginLeft_cm, marginBottom_cm, axWidth_cm, axHeight_cm];
    ax2_pos = [marginLeft_cm + axWidth_cm + gap_cm, marginBottom_cm, axWidth_cm, axHeight_cm];

    ax1 = axes(newFig, 'Units', 'centimeters', 'Position', ax1_pos);
    ax2 = axes(newFig, 'Units', 'centimeters', 'Position', ax2_pos);

    objs1 = findobj(ax1_old, '-not', 'Type', 'axes', '-and', 'Visible', 'on');
    objs2 = findobj(ax2_old, '-not', 'Type', 'axes', '-and', 'Visible', 'on');
    copyobj(objs1, ax1);
    copyobj(objs2, ax2);

    copyAxesProps(ax1_old, ax1);
    copyAxesProps(ax2_old, ax2);

    if ~isempty(leg1)
        lines1 = flipud(findobj(ax1, 'Type', 'line'));
        if ~isempty(lines1)
            newLeg1 = legend(ax1, lines1, leg1.String, 'Location', 'northeast');
        else
            newLeg1 = legend(ax1, leg1.String, 'Location', 'northeast');
        end
        newLeg1.Title.FontSize = leg1.Title.FontSize;
        newLeg1.Box = 'on';
    end

    if ~isempty(leg2)
        lines2 = flipud(findobj(ax2, 'Type', 'line'));
        if ~isempty(lines2)
            newLeg2 = legend(ax2, lines2, leg2.String, 'Location', 'northeast');
        else
            newLeg2 = legend(ax2, leg2.String, 'Location', 'northeast');
        end
        newLeg2.Title.FontSize = leg2.Title.FontSize;
        newLeg2.Box = 'on';
    end

    for ax = [ax1 ax2]
        ax.FontName   = 'Arial';
        ax.FontSize   = 9;
        ax.LineWidth  = 1;
        ax.Box        = 'on';
        ax.TickDir    = 'out';
        ax.TickLength = [0.015 0.015];
        ax.Layer      = 'top';
        ax.XGrid      = 'on';
        ax.YGrid      = 'on';
        ax.XLabel.Interpreter = 'latex';
        ax.YLabel.Interpreter = 'latex';
        ax.XLabel.FontName = 'Arial';
        ax.YLabel.FontName = 'Arial';
        ax.Title.FontName  = 'Arial';
        ax.XLabel.FontSize = 10;
        ax.YLabel.FontSize = 10;
        ax.Title.FontSize  = 10;
    end

    drawnow;
    ti1 = ax1.TightInset;
    ti2 = ax2.TightInset;

    ax1.Position = [ax1_pos(1) + ti1(1), ax1_pos(2) + ti1(2), ...
                    axWidth_cm - ti1(1) - ti1(3), axHeight_cm - ti1(2) - ti1(4)];
    ax2.Position = [ax2_pos(1) + ti2(1), ax2_pos(2) + ti2(2), ...
                    axWidth_cm - ti2(1) - ti2(3), axHeight_cm - ti2(2) - ti2(4)];

    figW = totalWidth_cm;
    figH = totalHeight_cm;
    ax1_norm = [ax1_pos(1)/figW, ax1_pos(2)/figH, ax1_pos(3)/figW, ax1_pos(4)/figH];
    ax2_norm = [ax2_pos(1)/figW, ax2_pos(2)/figH, ax2_pos(3)/figW, ax2_pos(4)/figH];

    annotation(newFig, 'textbox', [ax1_norm(1)-0.04, ax1_norm(2)+ax1_norm(4)+0.01, 0.03, 0.04], ...
        'String', panelLabels{1}, 'LineStyle', 'none', 'FontWeight', 'bold', ...
        'FontSize', 12, 'FontName', 'Arial');
    annotation(newFig, 'textbox', [ax2_norm(1)-0.04, ax2_norm(2)+ax2_norm(4)+0.01, 0.03, 0.04], ...
        'String', panelLabels{2}, 'LineStyle', 'none', 'FontWeight', 'bold', ...
        'FontSize', 12, 'FontName', 'Arial');

    makeSureSameHeight = get(ax2, 'Position') - get(ax1, 'Position');
    makeSureSameHeight([1, 3]) = 0;
    set(ax2, 'Position', get(ax2, 'Position') - makeSureSameHeight);

    if nargin >= 3 && ~isempty(outputBasePath)
        [outDir, baseName, ~] = fileparts(outputBasePath);
        if ~isempty(outDir) && ~exist(outDir, 'dir')
            mkdir(outDir);
        end
        savefig(newFig, fullfile(outDir, [baseName '.fig']));
        exportgraphics(newFig, fullfile(outDir, [baseName '.pdf']), 'ContentType', 'vector');
    end

    close(f1);
    close(f2);
end

function copyAxesProps(ax_old, ax_new)
    set(ax_new, ...
        'XLim', get(ax_old, 'XLim'), ...
        'YLim', get(ax_old, 'YLim'), ...
        'XScale', get(ax_old, 'XScale'), ...
        'YScale', get(ax_old, 'YScale'), ...
        'XDir', get(ax_old, 'XDir'), ...
        'YDir', get(ax_old, 'YDir'), ...
        'XTick', get(ax_old, 'XTick'), ...
        'YTick', get(ax_old, 'YTick'), ...
        'XTickLabel', get(ax_old, 'XTickLabel'), ...
        'YTickLabel', get(ax_old, 'YTickLabel'));

    xlabel(ax_new, ax_old.XLabel.String, 'Interpreter', ax_old.XLabel.Interpreter);
    ylabel(ax_new, ax_old.YLabel.String, 'Interpreter', ax_old.YLabel.Interpreter);
    title(ax_new,  ax_old.Title.String,  'Interpreter', ax_old.Title.Interpreter);
end

