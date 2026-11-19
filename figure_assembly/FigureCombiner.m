% File paths to your saved figures (.fig files)
%% scCombined
% fig1_path = 'Proportion_of_SC_Haplotypes.fig';
% fig2_path = 'Mean_SC_Proportion_Y.fig';
%% EffectiveCombined
% fig1_path = 'Effective_Number_of_Distinct_Haplotypes.fig';
% fig2_path = 'Effective_Number_Y.fig';
%% ClassifiedCombined
% fig1_path = 'Classified_Population_Proportion.fig';
% fig2_path = 'Classified_Proportion_Y.fig';
%% DeltaMuCD
% fig1_path = 'Mutation_of_mu_g.fig';
% fig2_path = 'Population_Mean_mu_g.fig';
%% DeltaMuEF
% fig1_path = 'Neutral_mu_g_of_Haplotypes.fig';
% fig2_path = '_mu_g_of_Haplotypes.fig';

%% NumClassCombined
% fig1_path = 'Number_of_Classes.fig' ; 
% fig2_path = 'Number_of_Classes_Y.fig' ;

%% NumClassCombined
% fig1_path = 'Probability_Y2.fig' ; 
% fig2_path = 'Proportion_of_Identical_SLFs_Y.fig' ;
%% scCombined2
% fig1_path = 'Proportion_of_SC_Haplotypes.fig';
% fig2_path = 'ProportionByRateSC.fig';
% 
% 
% fig1_path = 'AgeOfExtinction.fig' ;
% fig2_path = 'meanMuGInject.fig' ;
%% different mute rates

fig1_path = 'SCMute.fig' ;
fig2_path = 'amountOfDivitions.fig' ;


% -----------------------------
% Paper layout settings
% -----------------------------
totalWidth_cm   = 17.8;

marginLeft_cm   = 0.9;
marginRight_cm  = 0.4;
marginBottom_cm = 1.2;   % ? reduced from 1.9
marginTop_cm    = 0.9;
gap_cm          = 1;

usableWidth_cm = totalWidth_cm - marginLeft_cm - marginRight_cm - gap_cm;
axWidth_cm     = usableWidth_cm / 2;
axHeight_cm    = axWidth_cm * 0.61;

totalHeight_cm = marginBottom_cm + marginTop_cm + axHeight_cm;

% -----------------------------
% Open original figures
% -----------------------------
f1 = openfig(fig1_path, 'invisible');
f2 = openfig(fig2_path, 'invisible');

ax1_all = findall(f1, 'type', 'axes');
ax2_all = findall(f2, 'type', 'axes');

% --- extract legend BEFORE filtering axes ---
leg1 = findall(f1, 'Type', 'Legend');
leg2 = findall(f2, 'Type', 'Legend');

% remove legends/colorbars from axes list
ax1_all = ax1_all(~strcmp(get(ax1_all,'Tag'),'legend') & ...
                  ~strcmp(get(ax1_all,'Tag'),'Colorbar'));
ax2_all = ax2_all(~strcmp(get(ax2_all,'Tag'),'legend') & ...
                  ~strcmp(get(ax2_all,'Tag'),'Colorbar'));

ax1_old = ax1_all(1);
ax2_old = ax2_all(1);

% -----------------------------
% Create new figure
% -----------------------------
newFig = figure('Color', 'w', 'Units', 'centimeters');
newFig.Position = [2 2 totalWidth_cm totalHeight_cm];
newFig.PaperUnits = 'centimeters';
newFig.PaperSize = [totalWidth_cm totalHeight_cm];
newFig.PaperPosition = [0 0 totalWidth_cm totalHeight_cm];

% -----------------------------
% Create axes
% -----------------------------
ax1_pos = [marginLeft_cm, marginBottom_cm, axWidth_cm, axHeight_cm];
ax2_pos = [marginLeft_cm + axWidth_cm + gap_cm, marginBottom_cm, axWidth_cm, axHeight_cm];

ax1 = axes(newFig, 'Units', 'centimeters', 'Position', ax1_pos);
ax2 = axes(newFig, 'Units', 'centimeters', 'Position', ax2_pos);

% -----------------------------
% Copy plot content
% -----------------------------
% Only copy visible graphics objects (avoids hidden limit expanders)
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
% Restore legend (LEFT PLOT ONLY)
% -----------------------------
if ~isempty(leg1)
    % Get legend strings
    legStrings = leg1.String;

    % Get plotted objects in the new axes (lines only)
    lines = findobj(ax1, 'Type', 'line');

    % Reverse order (MATLAB stacks them backwards)
    lines = flipud(lines);

    % Recreate legend
    newLeg = legend(ax1, lines, legStrings, ...
        'Location', 'northeast');   % change if needed
set(newLeg,...
    'Position',[0.328373017114779 0.531621367057404 0.11755952256776 0.34350452329457]);

%     newLeg.Title.String = leg1.Title.String ;
%     newLeg.Title.Interpreter = leg1.Title.Interpreter ; 
    newLeg.Title.FontSize = leg1.Title.FontSize ;
    newLeg.Box = 'on';  % cleaner for papers
end

if ~isempty(leg2)
    % Get legend strings
    legStrings = leg2.String;

    % Get plotted objects in the new axes (lines only)
    lines = findobj(ax2, 'Type', 'line');

    % Reverse order (MATLAB stacks them backwards)
    lines = flipud(lines);

    % Recreate legend
    newLeg2 = legend(ax2, lines, legStrings, ...
        'Location', 'northeast');   % change if needed
set(newLeg2,...
    'Position',[0.861998953444367 0.531621367057404 0.11755952256776 0.34350452329457]);

%     newLeg2.Title.String = leg2.Title.String ;
%     newLeg2.Title.Interpreter = leg2.Title.Interpreter ; 
    newLeg2.Title.FontSize = leg2.Title.FontSize ;
    newLeg2.Box = 'on';  % cleaner for papers
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
    ax.XLabel.Interpreter = 'latex' ;
    ax.YLabel.Interpreter = 'latex' ;
    
    ax.XLabel.FontName = 'Arial';
    ax.YLabel.FontName = 'Arial';
    ax.Title.FontName  = 'Arial';
    ax.XLabel.Interpreter = 'latex' ;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    ax.Title.FontSize  = 10;
end

% -----------------------------
% Fix clipping
% -----------------------------
drawnow;

ti1 = ax1.TightInset;
ti2 = ax2.TightInset;

ax1.Position = [
    ax1_pos(1) + ti1(1), ...
    ax1_pos(2) + ti1(2), ...
    axWidth_cm - ti1(1) - ti1(3), ...
    axHeight_cm - ti1(2) - ti1(4)
];

ax2.Position = [
    ax2_pos(1) + ti2(1), ...
    ax2_pos(2) + ti2(2), ...
    axWidth_cm - ti2(1) - ti2(3), ...
    axHeight_cm - ti2(2) - ti2(4)
];

% -----------------------------
% Panel labels
% -----------------------------
figW = totalWidth_cm;
figH = totalHeight_cm;

ax1_norm = [ax1_pos(1)/figW, ax1_pos(2)/figH, ax1_pos(3)/figW, ax1_pos(4)/figH];
ax2_norm = [ax2_pos(1)/figW, ax2_pos(2)/figH, ax2_pos(3)/figW, ax2_pos(4)/figH];

annotation(newFig, 'textbox', ...
    [ax1_norm(1)-0.04, ax1_norm(2)+ax1_norm(4)+0.01, 0.03, 0.04], ...
    'String', 'A', ...
    'LineStyle', 'none', ...
    'FontWeight', 'bold', ...
    'FontSize', 12, ...
    'FontName', 'Arial');

annotation(newFig, 'textbox', ...
    [ax2_norm(1)-0.04, ax2_norm(2)+ax2_norm(4)+0.01, 0.03, 0.04], ...
    'String', 'B', ...
    'LineStyle', 'none', ...
    'FontWeight', 'bold', ...
    'FontSize', 12, ...
    'FontName', 'Arial');

makeSureSameHeight = get(ax2,'Position') - get(ax1,'Position') ;
makeSureSameHeight([1,3]) = 0 ;
set(ax2,'Position',get(ax2,'Position')- makeSureSameHeight) ;


% -----------------------------
% Export
% -----------------------------
exportgraphics(newFig, 'combined_figure.pdf', 'ContentType', 'vector');
exportgraphics(newFig, 'combined_figure.png', 'Resolution', 600);

% -----------------------------
% Close originals
% -----------------------------
close(f1);
close(f2);