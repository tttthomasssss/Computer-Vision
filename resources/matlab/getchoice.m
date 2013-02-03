function i = getchoice(prompt, default)
%GETCHOICE Get a y/n choice from the keyboard
%
%    I = GETCHOICE(PROMPT) prints the string PROMPT and waits for the
%    user to type y or n followed by return. Prompts again if input was
%    not y or n. Returns 1 if the input was y and 0 if it was n.
%
%    I = GETCHOICE(PROMPT, DEFAULT) does the same except that the
%    character DEFAULT is printed after the prompt, and if the user just
%    presses return the result corresponds to DEFAULT. DEFAULT must be
%    'y' or equivalently 1, 'n' or equivalently 0, or []. Setting DEFAULT
%    to [] is the same as omitting it.

% David Young, March 2002
% Copyright (c) University of Sussex

if nargin < 2
    default = [];
end
if ~isempty(default)
    if default == 1
        default = 'y';
    elseif default == 0
        default = 'n';
    end
end

i = 'y' == getchar(prompt, default, 'yn');
