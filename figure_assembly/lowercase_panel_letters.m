function lowercase_panel_letters(fig)
% Convert single capital-letter annotations/text in a figure to lowercase
% Example:
%   lowercase_panel_letters(gcf)

    if nargin < 1 || isempty(fig)
        fig = gcf;
    end

    % Find all text-like objects inside the figure
    objs = findall(fig, '-property', 'String');

    for k = 1:numel(objs)
        str = get(objs(k), 'String');

        % Handle normal char/string
        if ischar(str) || (isstring(str) && isscalar(str))
            s = char(str);

            % Change only single capital letters like 'A', 'B', ...
            if ~isempty(regexp(strtrim(s), '^[A-Z]$', 'once'))
                set(objs(k), 'String', lower(s));
            end

        % Handle cell arrays of strings
        elseif iscell(str)
            for i = 1:numel(str)
                if ischar(str{i}) || (isstring(str{i}) && isscalar(str{i}))
                    s = char(str{i});
                    if ~isempty(regexp(strtrim(s), '^[A-Z]$', 'once'))
                        str{i} = lower(s);
                    end
                end
            end
            set(objs(k), 'String', str);
        end
    end
end
