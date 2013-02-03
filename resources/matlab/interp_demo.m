function mlines = interp_demo(mlines)
%INTERP_DEMO Interpretation tree demo
%    INTERP_DEMO runs a demonstration of simple 2-D interpretation tree
%    matching. The user is invited to generate a model using the mouse,
%    and this is corrupted to produce a set of lines that might have come
%    from an image. The model and image lines are then matched using
%    search with binary angular constraints. Final validation of the
%    match is left to the user. The progress of the search is displayed.
%
%    MLINES = INTERP_DEMO runs the demonstration and returns the model
%    lines.
%
%    INTERP_DEMO(MLINES) runs the demonstration using the model lines
%    returned
%    by a previous call.
%
% See also INTERP_MATCH

% David Young, March 2002
% Copyright (c) University of Sussex

% The following m-files need to be in the path:
%
%    interp_read   interp_axes     interp_show   interp_corrupt
%    delete_col    shuffle_cols    interp_match
%    interp_test   interp_validate line_centres
%    getint        getchar         getnum        getchoice

disp(' ');
disp('     2-D Interpretation Tree matching demonstration');
disp('     ----------------------------------------------');
disp(' ');

clf reset;
set(clf, 'Name', 'Interpretation Tree matching', 'NumberTitle', 'off');

if nargin == 0
    mlines = interp_read;   % lines from mouse
else
    [mlines.handle] = deal([]);   % Check no handles set
end

mlines = interp_show(mlines);

disp(' ');
disp('The image lines are generated from the model by rotating,');
disp('scaling and shifting it random amounts. In addition some');
disp('model lines can be omitted at random, some extra lines added');
disp('at random, and the ends of the image lines wobbled about at');
disp('random. The order of the lines in the image is also');
disp('randomised.');
disp(' ');
disp('Enter the parameters for these operations now. If you give 0');
disp('for all 3, the image will be just like the model apart from');
disp('rotation, scaling and shifting. It is best to start with');
disp('this. Later omit or add only 1 or 2 lines, and add some');
disp('wobble, but keep it small - say about 2.');
disp(' ');

nomit = getint('Number of model lines to omit', 0);
nextra = getint('Number of extra image lines', 0);
wobble = getnum('Amount of wobble', 0);

ilines = interp_corrupt(mlines, nomit, nextra, wobble);
ilines = interp_show(ilines);

disp(' ');
disp('Now enter an angular tolerance for matching in degrees. If');
disp('this is too small and there is some wobble, you will miss');
disp('true matches. If it is too big then many false matches will');
disp('be accepted. If the wobble is 0, set the tolerance to');
disp('something small - say 1 degree. For a wobble of 2, and 5 lines,');
disp('a tolerance of 10-20 degrees should give reasonable results.');
disp(' ');

tol = pi * getnum('Angular tolerance ') / 180;

disp(' ');
disp('When a new match is considered, the program can either check');
disp('that it is consistent with all the previous matches, or just');
disp('with the immediately preceding match. The latter strategy');
disp('gives more false matches. Choose which of these to use now.');
disp(' ');

allcomp = getchoice('Carry out all comparisons?', 'y');

disp(' ');
disp('In the figure that appears now, your model is on the left');
disp('and the set of image lines on the right. Lines turn red when');
disp('they are the pair at the current node in the search tree,');
disp('and green when they are a match above the current node.');
disp('Model lines turn cyan then blue when they have been matched');
disp('with a wild card.');
disp(' ');
disp('You will need to press the return key to move on after each');
disp('new node is reached. Press return when you see this: >>');
disp('If you want the program to run until it finds a solution,');
disp('give the command "pause off" before starting.');
disp(' ');
disp('Validation of the match is at present manual - the best fit');
disp('of the model to the image is displayed and you will be asked');
disp('to accept it, or continue with the search.');
disp(' ');

% Search
interp_match(mlines, ilines, tol, allcomp);   % ignore result

% Reset figure and data structure
set(gcf, 'NextPlot', 'replace');
[mlines.handle] = deal([]);

end
