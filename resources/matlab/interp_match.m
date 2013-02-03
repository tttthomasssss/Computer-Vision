function m = interp_match(mlines, ilines, tol, allcomp)
%INTERP_MATCH Interpretation tree matching with angular constraints
%
%    M = INTERP_MATCH(MLINES, ILINES, TOL, ALLCOMP) carries out a search
%    using binary angular constraints to match the 'model' lines MLINES
%    to the 'image' lines ILINES. Progress is displayed graphically. TOL
%    is the tolerance in radians for accepting matches. ALLCOMP is 0 or 1
%    and controls whether each potential match is only checked against
%    the immediately preceding match (one node up in the tree) or against
%    all matches in the current hypothesis (all the way up in the tree).
%
%    MLINES should be as returned by GETLINES. ILINES should be as
%    returned by CORRUPT_LINES. The result M is 2xN structure array
%    giving the matched lines - first row is model lines, second
%    matching image lines.
%
%    For details of the general approach see David Young's computer
%    vision lecture notes or consult a textbook. Wild cards are
%    introduced gradually: first a match with none is tried, then with
%    one wild card, and so on. The search is ordered by the lines in the
%    first argument so is nominally model-driven, but can be made
%    image-driven simply by changing the order of the arguments.
%
%    The final match is validated by the user, although automatic
%    validation would be fairly straightforward.
%
%    The program pauses before each match is considered so that the user
%    can follow its progress. It will plough on to the next possible
%    solution if PAUSE OFF is given before it is called.
%
% See also INTERP_DEMO and associated functions.

% David Young, March 2002
% Copyright (c) University of Sussex

for nwild = 0:length(mlines)
    disp(['Trying matches with ' int2str(nwild) ' wild card(s)']);
    m = interp_match_r([], [], mlines, ilines, tol, nwild, ...
        [], allcomp);
    if ~isempty(m); break; end
end

end

% ---------------------------------------------------------------------

function m = interp_match_r(m0, i0, mrest, irest, tol, nwild, ...
        matches, allcomp)
% INTERP_MATCH_R
% Interpretation tree matching. m0, i0 are the current node. mrest
% is the set of unmatched model lines, irest set of unmatched image
% lines.
% matches are lines matched so far.
% (Roles of model and image lines may be reversed when this is called,
% but commented as if working from model lines.)
% Empty matrix used as wild card. nwild is number permitted in whole
% match.
% Assumes only one match per image or model line.
% Returns the matches as 2xn struct.

m = [];     % no match

if isempty(mrest)
    % Have matched all model lines
    m = interp_validate(addmatch(matches, m0, i0));
else
    [m1, mnext] = delete_col(mrest, 1); % Linked lists would be better!
    for i = 1:length(irest)
        [i1, inext] = delete_col(irest, i);
        
        % test for consistency
        ok = interp_test(m0, i0, [m1; i1], tol);
        if ok && allcomp; ok = interp_test(m1, i1, matches, tol); end
        
        if ok
            % OK at this level
            [m0,i0,m1,i1] = down(m0, i0, m1, i1);
            m = interp_match_r(m1, i1, mnext, inext, tol, nwild, ...
                addmatch(matches, m0, i0), allcomp);
            if ~isempty(m); break; end
            [m0,i0,m1,i1] = up(m0, i0, m1, i1); %#ok<*NASGU>
        end
    end
    % No match - use wild card if allowed
    if nwild && isempty(m)
        [m0,i0,m1,wild] = down(m0, i0, m1, []);
        m = interp_match_r(m1, [], mnext, irest, tol, nwild-1, ...
            addmatch(matches, m0, i0), allcomp);
        if ~isempty(m); return; end
        [m0,i0,m1,wild] = up(m0, i0, m1, []);
    end
end

end

% ---------------------------------------------------------------------

function [m0, i0, m1, i1] = down(m0, i0, m1, i1)
% Actions prior to next call
% Set colours - red for current match, cyan for active wildcards
% green for previous match, blue for matched wildcards.
if isempty(i0)
    m0 = interp_show(m0, 'b');
else
    m0 = interp_show(m0, 'g');
    i0 = interp_show(i0, 'g');
end

if isempty(i1)
    m1 = interp_show(m1, 'c');
    iname = '*';
else
    m1 = interp_show(m1, 'r');
    i1 = interp_show(i1, 'r');
    iname = int2str(i1.name);
end

spaces = '';
for i=1:m1.name
    spaces = [spaces, '  '];
end
mname = char('a' - 1 + m1.name);
disp([spaces, 'Matching ' mname ' with ' iname ' >>']);
pause;

end

% ---------------------------------------------------------------------

function [m0, i0, m1, i1] = up(m0, i0, m1, i1)
% Actions returning from next call
m0 = interp_show(m0, 'r');
i0 = interp_show(i0, 'r');
m1 = interp_show(m1, 'k');
i1 = interp_show(i1, 'k');
spaces = '';
for i=1:m1.name
    spaces = [spaces, '  '];
end
disp([spaces, 'Rejecting match']);
end

% ---------------------------------------------------------------------

function newmatches = addmatch(matches, m, i)
% Adds a match to the matches matrix, provided i is not empty
if isempty(i)       % wild card - don't record
    newmatches = matches;
elseif isempty(matches)
    newmatches = [m; i];     % needed as struct matrices
else
    newmatches = [matches, [m; i]];
end
end
