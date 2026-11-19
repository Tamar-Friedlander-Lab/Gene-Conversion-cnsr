% File paths to your saved figures (.fig files)
% fig1_path = 'figA.fig';   % top-left
% fig2_path = 'figB.fig';   % top-right
% fig3_path = 'figC.fig';   % bottom-left
% fig4_path = 'figD.fig';   % bottom-right
%% big mu
% fig1_path = 'Mutation_of_mu_g.fig';
% fig2_path = 'Population_Mean_mu_g.fig';
% 
% fig3_path = 'Neutral_mu_g_of_Haplotypes.fig';
% fig4_path = '_mu_g_of_Haplotypes.fig';

%% 
fig1_path = 'Number_of_Classes.fig' ; 
fig2_path = 'Number_of_Classes_Y.fig' ;

fig3_path = 'Classified_Population_Proportion.fig';
fig4_path = 'Classified_Proportion_Y.fig';


% -----------------------------
% Paper layout settings
% -----------------------------
totalWidth_cm   = 17.8;

marginLeft_cm   = 1.8;
marginRight_cm  = 0.4;
marginBottom_cm = 1.2;
marginTop_cm    = 1.5;

gapX_cm = 1.5;   % horizontal gap
gapY_cm = 2;   % vertical gap

usableWidth_cm = totalWidth_cm - marginLeft_cm - marginRight_cm - gapX_cm;
axWidth_cm     = usableWidth_cm / 2;
axHeight_cm    = axWidth_cm * 0.61;

totalHeight_cm = marginBottom_cm + marginTop_cm + 2*axHeight_cm + gapY_cm;

% -----------------------------
% Open original figures
% -----------------------------
f1 = openfig(fig1_path, 'invisible');
f2 = openfig(fig2_path, 'invisible');
f3 = openfig(fig3_path, 'invisible');
f4 = openfig(fig4_path, 'invisible');

[ax1_old, leg1] = extractAxisAndLegend(f1);
[ax2_old, leg2] = extractAxisAndLegend(f2);
[ax3_old, leg3] = extractAxisAndLegend(f3);
[ax4_old, leg4] = extractAxisAndLegend(f4);

% -----------------------------
% Create new figure
% -----------------------------
newFig = figure('Color', 'w', 'Units', 'centimeters');
newFig.Position = [2 2 totalWidth_cm totalHeight_cm];
newFig.PaperUnits = 'centimeters';
newFig.PaperSize = [totalWidth_cm totalHeight_cm];
newFig.PaperPosition = [0 0 totalWidth_cm totalHeight_cm];

% -----------------------------
% Axes positions (2x2 grid)
% -----------------------------
% Top row
ax1_pos = [marginLeft_cm, marginBottom_cm + axHeight_cm + gapY_cm, axWidth_cm, axHeight_cm];
ax2_pos = [marginLeft_cm + axWidth_cm + gapX_cm, marginBottom_cm + axHeight_cm + gapY_cm, axWidth_cm, axHeight_cm];

% Bottom row
ax3_pos = [marginLeft_cm, marginBottom_cm, axWidth_cm, axHeight_cm];
ax4_pos = [marginLeft_cm + axWidth_cm + gapX_cm, marginBottom_cm, axWidth_cm, axHeight_cm];

ax1 = axes(newFig, 'Units', 'centimeters', 'Position', ax1_pos);
ax2 = axes(newFig, 'Units', 'centimeters', 'Position', ax2_pos);
ax3 = axes(newFig, 'Units', 'centimeters', 'Position', ax3_pos);
ax4 = axes(newFig, 'Units', 'centimeters', 'Position', ax4_pos);

% -----------------------------
% Copy content
% -----------------------------
copyAxes(ax1_old, ax1);
copyAxes(ax2_old, ax2);
copyAxes(ax3_old, ax3);
copyAxes(ax4_old, ax4);

% -----------------------------
% Restore legends
% -----------------------------
restoreLegend(ax1, leg1);
restoreLegend(ax2, leg2);
restoreLegend(ax3, leg3);
restoreLegend(ax4, leg4);

% -----------------------------
% Formatting
% -----------------------------
for ax = [ax1 ax2 ax3 ax4]
    ax.FontName   = 'Arial';
    ax.FontSize   = 9;
    ax.LineWidth  = 1;
    ax.Box        = 'on';
    ax.TickDir    = 'out';
    ax.TickLength = [0.015 0.015];
    ax.Layer      = 'top';
    ax.XGrid = 'on';
    ax.YGrid = 'on';

    ax.XLabel.Interpreter = 'latex';
    ax.YLabel.Interpreter = 'latex';

    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    ax.Title.FontSize  = 10;
end

% -----------------------------
% Panel labels
% -----------------------------
annotation(newFig,'textbox',[0.06 0.93 0.03 0.04],'String','A','LineStyle','none','FontWeight','bold','FontSize',12);
annotation(newFig,'textbox',[0.53 0.93 0.03 0.04],'String','B','LineStyle','none','FontWeight','bold','FontSize',12);
annotation(newFig,'textbox',[0.06 0.45 0.03 0.04],'String','C','LineStyle','none','FontWeight','bold','FontSize',12);
annotation(newFig,'textbox',[0.53 0.45 0.03 0.04],'String','D','LineStyle','none','FontWeight','bold','FontSize',12);

% -----------------------------
% Export
% -----------------------------
print(newFig, 'combined_2x2', '-dpdf', '-painters');
print(newFig, 'combined_2x2', '-dpng', '-r600');

% -----------------------------
% Close originals
% -----------------------------
close([f1 f2 f3 f4]);

%% ============================
%% Helper functions
%% ============================

function [ax_old, leg] = extractAxisAndLegend(fig)
    ax_all = findall(fig, 'type', 'axes');
    leg = findall(fig, 'Type', 'Legend');

    ax_all = ax_all(~strcmp(get(ax_all,'Tag'),'legend') & ...
                    ~strcmp(get(ax_all,'Tag'),'Colorbar'));

    ax_old = ax_all(1);
end

function copyAxes(ax_old, ax_new)
    objs = findobj(ax_old, '-not', 'Type', 'axes', '-and', 'Visible', 'on');
    copyobj(objs, ax_new);

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

function restoreLegend(ax, leg_old)
    if isempty(leg_old)
        return;
    end

    lines = findobj(ax, 'Type', 'line');
    lines = flipud(lines);

    newLeg = legend(ax, lines, leg_old.String, 'Location', 'northeast');
    newLeg.Box = 'on';
    newLeg.FontSize = 8;
end