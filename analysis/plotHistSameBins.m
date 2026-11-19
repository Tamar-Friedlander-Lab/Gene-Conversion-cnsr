
function plotHistSameBins(dataCell, numBins, labels)

    if nargin < 2
        numBins = 30;
    end
    figure;
    hold on;

    % --- 1. Compute global bin edges ---
    allData = vertcat(dataCell{:});
    edges = linspace(min(allData), max(allData), numBins+1);

    % --- 2. Loop over datasets ---
    for i = 1:length(dataCell)

        data = dataCell{i};

        % Histogram with SAME bins
        counts = histcounts(data, edges);

        % Bin centers
        centers = (edges(1:end-1) + edges(2:end)) / 2;

        % Normalize to density (optional but recommended)
        counts = counts / trapz(centers, counts);

        % Smooth slightly (optional)
        counts = smoothdata(counts, 'gaussian', 3);

        % Plot as curve
        plot(centers, counts, 'LineWidth', 2);
    end

    hold off;
    grid on;

    xlabel('Value', 'Interpreter', 'tex');
    ylabel('Density', 'Interpreter', 'tex');

    if nargin > 2
        legend(labels, 'Location', 'best');
    end
end





