function [name,val,dbg] = nextname(bnm,sfx,ext,otp)
% Return the next unused filename, incrementing a numbered suffix if required.
%
% (c) 2017-2024 Stephen Cobeldick
%
%%% Syntax:
% name = nextname(bnm,sfx,ext)
% name = nextname(bnm,sfx,ext,otp)
% [name,val] = nextname(...)
%
% The basename is supplied as the first input. If the location to be
% checked is not the current directory then the basename must use a
% relative or absolute path to that location. The basename is treated
% as literal text. The second input is a suffix that will be appended
% to the basename: the suffix must contain exactly one starting integer,
% e.g.: '(0)', '_1', ' v005', '.temp.1000', etc., and NEXTNAME increments
% the integer value so that the returned name is currently unused by any
% file/folder. The third input is the file extension: for folders (or if
% the file does not require an extension) use empty text, i.e. '' or "".
%
% Padding the suffix integer with leading zeros indicates the required
% number length, thus allowing for the creation of fixed-width names.
%
% Duplicate number values will not be returned, regardless of any leading
% zeros in the existing file/folder names or in the requested suffix.
%
%% Examples %%
%
%%% Current directory contains files 'A1.txt', 'A2.txt', and 'A4.txt':
%
% >> nextname("A","1",".txt")
% ans = "A3.txt"
%
% >> nextname("A","001",".txt")
% ans = "A003.txt"
%
%%% Subdirectory 'HTML' contains folders 'B(1)', 'B(2)', and 'B(4)':
%
% >> nextname('HTML/B','(1)','')
% ans = 'B(3)'
%
% >> nextname('HTML/B','(001)','')
% ans = 'B(003)'
%
% >> nextname('HTML/B','(1)','',false) % default = name only.
% ans = 'B(3)'
% >> nextname('HTML/B','(1)','',true) % with the path from the input name.
% ans = 'HTML/B(3)'
%
%% Inputs and Outputs %%
%
%%% Input Arguments (**==default):
% bnm = CharVector or StringScalar giving the base filename or folder name,
%       with an absolute or relative file path if required.
% sfx = CharVector or StringScalar of the suffix to append. Must contain
%       exactly one integer number (i.e. the value to increment from).
% ext = CharVector or StringScalar of the file extension, if any.
%       For folder names (or filenames without extensions) use '' or "".
% otp = LogicalScalar, true/false** -> output with same path as input name / name only.
%
%%% Output Arguments:
% name = A currently unused file/folder name. Has the same class as <bnm>.
% val  = NumericScalar, the value used in the returned <name>.
%
% See also: DIR EXIST FILEPARTS FULLFILE MKDIR FOPEN FCLOSE SPRINTF
% ARBSORT NATSORT NATSORTFILES NATSORTROWS ISFILE ISFOLDER WHAT WHICH WHO
%% Input Wrangling %%
%
iss = isa(bnm,'string');
bnm = nn1s2c(bnm);
sfx = nn1s2c(sfx);
ext = nn1s2c(ext);
chk = @(a,f)ischar(a) && ndims(a)==2 && f(size(a,1),1); %#ok<ISMAT>
%
msg = 'Input <%s> must be a scalar string or a 1xN character vector.';
assert(chk(bnm,@eq),'SC:nextname:bnm:NotText',msg,'bnm')
assert(chk(sfx,@eq),'SC:nextname:sfx:NotText',msg,'sfx')
assert(chk(ext,@le),'SC:nextname:ext:NotText',msg,'ext')
%
tkn = regexp(sfx,'\d+','match');
val = sscanf(sprintf(' %s',tkn{:}),'%lu'); % faster than STR2DOUBLE.
assert(isscalar(val),'SC:nextname:sfx:NotOneInteger','%s\n',...
	'The suffix <sfx> must contain exactly one integer value',...
	'The integer may have any number of digits, with optional leading zeros.')
wid = numel(tkn{1});
%
%% Get Existing File / Folder Names %%
%
[inpth,fnm,tmp] = fileparts(bnm);
fnm = [fnm,tmp];
%
% Find files/subfolders on that path:
raw = dir(fullfile(inpth,[fnm,regexprep(sfx,'\d+','*'),ext]));
%
% Special case of exactly one matching subfolder (Octave):
if ~all(strncmp({raw.name},fnm,numel(fnm)))
	raw = dir(fullfile(inpth,'*'));
end
%
% Generate regular expression:
rgx = regexprep(regexptranslate('escape',sfx),'\d+','(\\d+)');
rgx = ['^',regexptranslate('escape',fnm),rgx,regexptranslate('escape',ext),'$'];
%
% Extract numbers from names:
tkn = regexpi({raw.name},rgx,'tokens','once');
tkn = [tkn{:}];
%
%% Identify First Unused Name %%
%
if numel(tkn)
	% For speed these values must be converted before the WHILE loop:
	vec = sscanf(sprintf(' %s',tkn{:}),'%lu');  % faster than STR2DOUBLE.
	mxv = intmax('uint64');
	%
	% Find the first unused name, starting from the provided value:
	while any(val==vec) && val<mxv
		val = val+1;
	end
	%
	% Throw error if VAL reaches INTMAX... which is also in VEC:
	assert(all(val~=vec),...
		'SC:nextname:sfx:NoUnusedInteger',...
		'No unused integer could be found.')
end
%
name = [fnm,regexprep(sfx,'\d+',sprintf('%0*u',wid,val)),ext];
%
if nargin>3
	assert(isequal(otp,0)||isequal(otp,1),...
		'SC:nextname:otp:NotLogicalScalar',...
		'Input <otp> must be a scalar logical (i.e. true or false).')
	if otp
		name = fullfile(inpth,name);
	end
end
%
if iss
	name = string(name);
end
%
if nargout>2
	dbg = struct('dir',raw, 'numbers',{tkn}, 'regexp',rgx);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nextname
function arr = nn1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
	arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%