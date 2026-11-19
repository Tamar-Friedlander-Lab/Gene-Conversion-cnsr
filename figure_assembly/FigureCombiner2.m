% File paths to your saved figures (.fig files)
% fig1_path = 'Proportion_of_SC_Haplotypes.fig';
% fig2_path = 'Mean_SC_Proportion_Y.fig';

% fig1_path = 'Effective_Number_of_Distinct_Haplotypes.fig';
% fig2_path = 'Effective_Number_Y.fig';

% fig1_path = 'Classified_Population_Proportion.fig';
% fig2_path = 'Classified_Proportion_Y.fig';

% fig1_path = 'Mutation_of_mu_g.fig';
% fig2_path = 'Population_Mean_mu_g.fig';

% fig1_path = 'Neutral_mu_g_of_Haplotypes.fig';
% fig2_path = '_mu_g_of_Haplotypes.fig';

fig1_path = 'Mutation_of_mu_g.fig';
fig2_path = 'Proportion_of_Identical_SLFs_Y.fig';

% -----------------------------
% Figure size (INSTRUCTOR STYLE)
% -----------------------------
totalWidth_cm  = 17.8;
totalHeight_cm = 0.61 * totalWidth_cm;

newFig = figure('Color', 'w', 'Units', 'centimeters');
newFig.Position = [2 2 totalWidth_cm totalHeight_cm];
newFig.PaperUnits = 'centimeters';
newFig.PaperSize = [totalWidth_cm totalHeight_cm];
newFig.PaperPosition = [0 0 totalWidth_cm totalHeight_cm];

% -----------------------------
% Open original figures
% -----------------------------
f1 = openfig(fig1_path, 'invisible');
f2 = openfig(fig2_path, 'invisible');

ax1_all = findall(f1, 'type', 'axes');
ax2_all = findall(f2, 'type', 'axes');

% Extract legends
leg1 = findall(f1, 'Type', 'Legend');
leg2 = findall(f2, 'Type', 'Legend');

% Remove legends/colorbars
ax1_all = ax1_all(~strcmp(get(ax1_all,'Tag'),'legend') & ...
                  ~strcmp(get(ax1_all,'Tag'),'Colorbar'));
ax2_all = ax2_all(~strcmp(get(ax2_all,'Tag'),'legend') & ...
                  ~strcmp(get(ax2_all,'Tag'),'Colorbar'));

ax1_old = ax1_all(1);
ax2_old = ax2_all(1);

% -----------------------------
% Create axes (INSTRUCTOR STYLE)
% -----------------------------
ax1 = axes(newFig, 'Units', 'normalized', ...
    'Position', [0.10 0.20 0.38 0.70]);

ax2 = axes(newFig, 'Units', 'normalized', ...
    'Position', [0.57 0.20 0.38 0.70]);

% -----------------------------
% Copy plot content (visible only)
% -----------------------------
objs1 = findobj(ax1_old, '-not', 'Type', 'axes', '-and', 'Visible', 'on');
objs2 = findobj(ax2_old, '-not', 'Type', 'axes', '-and', 'Visible', 'on');

copyobj(objs1, ax1);
copyobj(objs2, ax2);

% -----------------------------
% Copy axes properties
% -----------------------------
set(ax1, ...
    'XLim', get(ax1_old, 'XLim'), ...
    'YLim', get(ax1_old, 'YLim'), ...
    'XScale', get(ax1_old, 'XScale'), ...
    'YScale', get(ax1_old, 'YScale'), ...
    'XDir', get(ax1_old, 'XDir'), ...
    'YDir', get(ax1_old, 'YDir'), ...
    'XTick', get(ax1_old, 'XTick'), ...
    'YTick', get(ax1_old, 'YTick'), ...
    'XTickLabel', get(ax1_old, 'XTickLabel'), ...
    'YTickLabel', get(ax1_old, 'YTickLabel'));

set(ax2, ...
    'XLim', get(ax2_old, 'XLim'), ...
    'YLim', get(ax2_old, 'YLim'), ...
    'XScale', get(ax2_old, 'XScale'), ...
    'YScale', get(ax2_old, 'YScale'), ...
    'XDir', get(ax2_old, 'XDir'), ...
    'YDir', get(ax2_old, 'YDir'), ...
    'XTick', get(ax2_old, 'XTick'), ...
    'YTick', get(ax2_old, 'YTick'), ...
    'XTickLabel', get(ax2_old, 'XTickLabel'), ...
    'YTickLabel', get(ax2_old, 'YTickLabel'));

% -----------------------------
% Copy labels and titles
% -----------------------------
xlabel(ax1, ax1_old.XLabel.String, 'Interpreter', ax1_old.XLabel.Interpreter);
ylabel(ax1, ax1_old.YLabel.String, 'Interpreter', ax1_old.YLabel.Interpreter);
title(ax1,  ax1_old.Title.String,  'Interpreter', ax1_old.Title.Interpreter);

xlabel(ax2, ax2_old.XLabel.String, 'Interpreter', ax2_old.XLabel.Interpreter);
ylabel(ax2, ax2_old.YLabel.String, 'Interpreter', ax2_old.YLabel.Interpreter);
title(ax2,  ax2_old.Title.String,  'Interpreter', ax2_old.Title.Interpreter);

% -----------------------------
% Restore legends
% -----------------------------
if ~isempty(leg1)
    lines = findobj(ax1, 'Type', 'line');
    lines = flipud(lines);

    newLeg = legend(ax1, lines, leg1.String, 'Location', 'northeast');
    newLeg.Title.String = leg1.Title.String;
    newLeg.Title.Interpreter = leg1.Title.Interpreter;
    newLeg.Title.FontSize = leg1.Title.FontSize;
    newLeg.Box = 'on';
    newLeg.FontSize = 8;
end

if ~isempty(leg2)
    lines = findobj(ax2, 'Type', 'line');
    lines = flipud(lines);

    newLeg2 = legend(ax2, lines, leg2.String, 'Location', 'northeast');
    newLeg2.Title.String = leg2.Title.String;
    newLeg2.Title.Interpreter = leg2.Title.Interpreter;
    newLeg2.Title.FontSize = leg2.Title.FontSize;
    newLeg2.Box = 'on';
    newLeg2.FontSize = 8;
end

% -----------------------------
% Formatting
% -----------------------------
for ax = [ax1 ax2]
    ax.FontName   = 'Arial';
    ax.FontSize   = 9;
    ax.LineWidth  = 1;
    ax.Box        = 'on';
    ax.TickDir    = 'out';
    ax.TickLength = [0.015 0.015];
    ax.Layer      = 'top';
    ax.XGrid = 'on';
    ax.YGrid = 'on';

    ax.XLabel.FontName = 'Arial';
    ax.YLabel.FontName = 'Arial';
    ax.Title.FontName  = 'Arial';

    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    ax.Title.FontSize  = 10;
end

% -----------------------------
% Panel labels
% -----------------------------
annotation(newFig, 'textbox', [0.06 0.92 0.03 0.05], ...
    'String', 'A', 'LineStyle', 'none', ...
    'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Arial');

annotation(newFig, 'textbox', [0.53 0.92 0.03 0.05], ...
    'String', 'B', 'LineStyle', 'none', ...
    'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Arial');

% -----------------------------
% Export (use print if needed)
% -----------------------------
print(newFig, 'combined_figure', '-dpdf', '-painters');
print(newFig, 'combined_figure', '-dpng', '-r600');

% -----------------------------
% Close originals
% -----------------------------
close(f1);
close(f2);