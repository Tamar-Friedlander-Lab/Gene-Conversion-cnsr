function linearFitFromFigure(fig)
% Creates a new figure:
% X = numeric values parsed from legend
% Y = mean of each plot
% Error = standard deviation
% Includes linear fit


halfPageWidth_cm = 8.5;
figureHeight_cm  = 6.0;

fontSizeAxes   = 10;
fontSizeLabels = 11;
lineWidth      = 2;



    nuFig = figure;

    % ---- Figure size ----
    set(nuFig, 'Units','centimeters', ...
             'Position',[2 2 halfPageWidth_cm figureHeight_cm], ...
             'PaperUnits','centimeters', ...
             'PaperSize',[halfPageWidth_cm figureHeight_cm], ...
             'PaperPosition',[0 0 halfPageWidth_cm figureHeight_cm]);
    pause(0.1)
    hold on;


    ax = findobj(fig, 'Type', 'axes');
    lines = findobj(ax, 'Type', 'line');

    % Reverse so order matches legend
    lines = flipud(lines);

    % Get legend
    lgd = findobj(fig, 'Type', 'legend');
    assert(~isempty(lgd), 'No legend found in figure');

    legendStrings = lgd.String;
    N = numel(lines);

    assert(numel(legendStrings) == N, ...
        'Number of legend entries does not match number of plots');

    xVals  = zeros(N,1);
    means  = zeros(N,1);
    stds   = zeros(N,1);

    normalization = (str2double(ax.XTickLabel(end,:)) - str2double(ax.XTickLabel(1,:)))./(ax.XTick(end)-ax.XTick(1)) ;  

    for i = 1:N
        y = lines(i).YData;

        y4Mean = y.*normalization.*lines(i).XData ;

        means(i) = sum(y4Mean, 'omitnan') ;
        stds(i)  = std(y,  'omitnan');
        [mu, stds(i)] = meanStdFromCurve(normalization.*lines(i).XData, y) ;
        % Extract first numeric value from legend string
        tokens = regexp(legendStrings{i}, ...
            '[-+]?\d*\.?\d+([eE][-+]?\d+)?', 'match');

        assert(~isempty(tokens), ...
            'Could not extract numeric value from legend: %s', ...
            legendStrings{i});

        if length(tokens)==2
            xVals(i) = str2double(tokens{1})./str2double(tokens{2});
        else

        xVals(i) = str2double(tokens{1});
        end
    end

    % Linear fit
    p = polyfit(xVals, means, 1);
    xFit = linspace(min(xVals), max(xVals), 100);
    yFit = polyval(p, xFit);

    % Plot summary
    errorbar(xVals, means, stds, 'o', ...
        'LineWidth', 1.5, 'MarkerSize', 7);
    hold on;
    plot(xFit, yFit, '--', 'LineWidth', 2);
    hold off;

    grid on;
    xlabel('Gene Conversion Rate');
    ylabel(fig.Children(end).XLabel.String);
   % title('Mean ± STD vs Legend Value');

    %fitStr = sprintf('y = %.3f x + %.3f', p(1), p(2));
    %legend('Mean \pm STD', fitStr, 'Location', 'best');
       title('');


    nuFig.Children(end).LineWidth = 1;
    nuFig.Children(end).TickDir = 'out';

    nuFig.Children(end).XLabel.FontSize = fontSizeLabels ;
    nuFig.Children(end).YLabel.FontSize = fontSizeLabels ;


    
end
