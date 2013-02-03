function i = getchar(prompt, default, options)
%GETCHAR Read a character from the keyboard
%
%    I = GETCHAR(PROMPT) prints the string PROMPT and waits for the user
%    to type a character followed by return. Checks that the input is a
%    single character and prompts again if necessary. Returns the
%    character.
%
%    I = GETCHAR(PROMPT, DEFAULT) does the same except that the character
%    DEFAULT is printed after the prompt, and is returned if the user
%    just presses return. Setting DEFAULT to [] is the same as omitting
%    it.
%
%    I = GETCHAR(PROMPT, DEFAULT, OPTIONS) does the same except that the
%    string OPTIONS is also printed after the prompt, and the input
%    character must be one of the characters in OPTIONS; if not the
%    prompt is repeated until it is. It is an error for DEFAULT not to be
%    in OPTIONS. Setting OPTIONS to [] is the same as omitting it.

% David Young, March 2002
% Copyright (c) University of Sussex

if nargin < 3
    options = [];
end
if ~isempty(options)
    if ~ischar(options) || size(options, 1) ~= 1
        error('Expecting options argument to be character string');
    end
    prompt = [prompt, ' (options: ', options, ')'];
end

if nargin < 2
    default = [];
end
if ~isempty(default)
    if ~instr(default, options)
        error('Expecting single character default argument from options');
    end
    prompt = [prompt, ' [', default, '] '];
end

i = [];
while isempty(i)
    i = input(prompt, 's');
    if isempty(i) && ~isempty(default)
        i = default;
    else
        if ~instr(i, options)
            disp('Unexpected input');
            i = [];
        end
    end
end


function i = instr(x, s)
% Checks if x occurs in the string or strings s
% Returns false if x not a single char; true if x is a single
% char but s is empty.
i = checkchar(x);
if i
    i = isempty(s);
    if ~i
        i = ~isempty(find(s == x, 1));
    end
end


function i = checkchar(x)
% Checks whether its argument is a single character
i = ischar(x) & length(x) == 1;
