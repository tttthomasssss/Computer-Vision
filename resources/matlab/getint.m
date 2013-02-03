function i = getint(prompt, default)
%GETINT Read an integer value from the keyboard
%
%    I = GETINT(PROMPT) prints the string PROMPT and waits for the user
%    to type an integer followed by return. Checks that the input does
%    actually represent an integer and prompts again if necessary.
%    Returns the integer.
%
%    I = GETINT(PROMPT, DEFAULT) does the same except that the integer
%    DEFAULT is printed after the prompt, and is returned if the user
%    just presses return. Setting DEFAULT to [] is the same as omitting
%    it.

% David Young, March 2002
% Copyright (c) University of Sussex

if nargin < 2
    default = [];
end
if isempty(default)
    str = prompt;
else
    if ~checkint(default)
        error('Expecting integer default argument');
    end;
    str = [prompt, ' [', int2str(default), '] '];
end;

i = [];
while isempty(i)
    i = input(str, 's');
    if isempty(i) && ~isempty(default)
        i = default;
    else
        i = str2num(i);
        if ~checkint(i)
            disp('A single integer expected');
            i = [];
        end
    end
end
end


function i = checkint(x)
% Checks whether its argument is a single integer
i = isnumeric(x) && isscalar(x) && round(x) == x;
end
