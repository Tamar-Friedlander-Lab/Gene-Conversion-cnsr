function convert_fig_letters(input_fig_path, output_folder)
% Convert capital single-letter annotations in a saved .fig file to lowercase
% and save to a new folder

    % Create output folder if it doesn't exist
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Open the figure (invisible so it doesn't pop up)
    fig = openfig(input_fig_path, 'visible');

    % ---- APPLY YOUR EXISTING LOGIC ----
    objs = findall(fig, '-property', 'String');

    for k = 1:numel(objs)
        str = get(objs(k), 'String');

        if ischar(str) || (isstring(str) && isscalar(str))
            s = char(str);
            if ~isempty(regexp(strtrim(s), '^[A-Z]$', 'once'))
                set(objs(k), 'String', lower(s));
            end

        elseif iscell(str)
            for i = 1:numel(str)
                s = char(str{i});
                if ~isempty(regexp(strtrim(s), '^[A-Z]$', 'once'))
                    str{i} = lower(s);
                end
            end
            set(objs(k), 'String', str);
        end
    end
    % ----------------------------------

    % Extract file name
    [~, name, ext] = fileparts(input_fig_path);

    % Save to new folder
    output_path = fullfile(output_folder, [name, ext]);

    savefig(fig, output_path);
print(fig, fullfile(output_folder, [name '.pdf']), '-dpdf', '-bestfit');
    % Close figure to avoid memory issues
    close(fig);

    fprintf('Saved: %s\n', output_path);
    
end