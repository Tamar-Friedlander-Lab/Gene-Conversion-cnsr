% ===== USER INPUT =====
if ~exist('outputFolder', 'var') || isempty(outputFolder)
    repoRoot = fileparts(fileparts(mfilename('fullpath')));
    outputFolder = fullfile(repoRoot, 'PaperResults');
end
% ======================

fig = gcf;
ax  = gca;

% Get xlabel text
label = ax.YLabel.String;

if isempty(label)
    error('YLabel is empty. Cannot use it as filename.');
end

% Convert to valid filename
label = char(label);                 % ensure char
label = strtrim(label);
label = regexprep(label, '[^\w\-]', '_');  % replace illegal chars
label = regexprep(label, '_+', '_');       % clean repeats

label = [label,'_Y'] ;

% Create folder if needed
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Full paths
figPath = fullfile(outputFolder, [label '.fig']);
pdfPath = fullfile(outputFolder, [label '.pdf']);

% Save
savefig(fig, figPath);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');

disp(['Saved as: ' label '.fig and .pdf']);
