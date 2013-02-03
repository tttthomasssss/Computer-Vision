function i = getreal(prompt, default)
% GETREAL Read a real numerical value from the keyboard
%
%    I = GETREAL(PROMPT) prints the string PROMPT and waits for the user
%    to type an number followed by return. Checks that the input does
%    actually represent a real scalar and prompts again if necessary.
%    Returns the number.
%
%    I = GETREAL(PROMPT, DEFAULT) does the same except that the number
%    DEFAULT is printed after the prompt, and is returned if the user
%    just presses return. Setting DEFAULT to [] is the same as omitting
%    it.

% David Young, March 2007
% Copyright (c) University of Sussex


if nargin < 2
    default = [];
end
if isempty(default)
    str = prompt;
else
    if ~checknum(default)
        error('Expecting numerical default argument');
    end;
    str = [prompt, ' [', num2str(default), '] '];
end;

i = [];
while isempty(i)
    i = input(str, 's');
    if isempty(i) && ~isempty(default)
        i = default;
    else
        i = str2num(i);
        if ~checknum(i)
            disp('A single real number expected');
            i = [];
        end
    end
end
end


function i = checknum(x)
% Checks whether its argument is a single real number
i = isnumeric(x) && isscalar(x) && isreal(x);
end
