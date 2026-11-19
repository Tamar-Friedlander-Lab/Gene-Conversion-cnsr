function ChangeFigure2Format(fig)

%FORMATMATFOLDERFORPAPER
%   Scans folder recursively, loads all .mat files, and exports
%   publication-ready figures (half-page width, no legend/title).

% -------- Parameters (fixed) --------
halfPageWidth_cm = 8.5;
figureHeight_cm  = 6.0;

fontSizeAxes   = 10;
fontSizeLabels = 11;
lineWidth      = 2;




% ---- Figure size ----
set(fig, 'Units','centimeters', ...
    'Position',[2 2 halfPageWidth_cm figureHeight_cm], ...
    'PaperUnits','centimeters', ...
    'PaperSize',[halfPageWidth_cm figureHeight_cm], ...
    'PaperPosition',[0 0 halfPageWidth_cm figureHeight_cm]);

hold on;


% ---- Formatting ----

%    fig.FontSize = fontSizeAxes;
fig.Children(end).LineWidth = 1;
fig.Children(end).TickDir = 'out';

fig.Children(end).XLabel.FontSize = fontSizeLabels ;
fig.Children(end).YLabel.FontSize = fontSizeLabels ;

amountOfLines = length(fig.Children(end).Children) ;

for i = 1:amountOfLines

    fig.Children(end).Children(i).LineWidth = lineWidth ;

end


grid on;
box on;
%    legend off;
title('');

% ===== ADD THIS BLOCK =====
ax = gca;
ax.Units = 'normalized';
ax.Position = [0.155    0.2030    0.7552    0.7220];
%ax.FontSize = fontSizeAxes;
%ax.LineWidth = 1;
ax.TickDir = 'out';
%ax.TickLength = [0.015 0.015];
%ax.XMinorTick = 'off';
%ax.YMinorTick = 'off';
%ax.LooseInset = ax.TightInset;
%ax.Box = 'on';
% =========================


end


