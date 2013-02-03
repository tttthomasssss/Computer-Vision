function y = interp_validate(m)
%INTERP_VALIDATE  Checks whether the match set is valid
%    Y = INTERP_VALIDATE(M)takes as input a 2xN struct matrix in which each
%    column has a model line and an image line, in the format established
%    by INTERP_READ.
%
%    Finds a transformation between the 2 sets of lines by getting
%    their centre points and finding the linear transform that maps
%    them best in least squares sense. Displays the result and asks for
%    manual verification. Returns the matches if they are agreed,
%    otherwise the empty matrix.
%
% See also INTERP_DEMO, INTERP_READ

% David Young, March 2002, 2009
% Copyright (c) University of Sussex

disp('Match found');

y = [];

if length(m) < 3
    if getchoice('Too few matched lines to validate. End search?', 'n')
        y = m;
    end
else
    mlines = [m(1, :).linedata];    % extract line data array
    ilines = [m(2, :).linedata];

    mpts = line_centres(mlines);
    ipts = line_centres(ilines);

    t = find_transform(mpts, ipts);

    % Apply transformation to model line ends
    mp1 = apply_transform(t, mlines(1:2, :));
    mp2 = apply_transform(t, mlines(3:4, :));

    % Construct transformed model line structure
    newmlines = m(1, :);
    for i = 1:length(newmlines)
        newmlines(i).linedata = [mp1(:,i); mp2(:,i)];
    end
    [newmlines.handle] = deal([]);
    [newmlines.type] = deal('i');   % now in image space

    % Display it on image
    newmlines = interp_show(newmlines, 'm', 0);  % do not show labels

    if getchoice('End search?', 'n')
        y = m;
    else
        interp_show(newmlines, []);
    end
end

end

function t = find_transform(x, y)
%FIND_TRANSFORM Finds a best fit linear transform between sets of points
%
%    T = FIND_TRANSFORM(X, Y) finds a transform A*X+B that maps the
%    columns of X onto the columns of Y with minimum sum of squares
%    error. Result T is [A, B].

xp = [x; ones(1, size(x,2))];
t = y / xp;
end

function y = apply_transform(t, x)
%APPLY_TRANSFORM Applies a linear transform to each column of the input
%
%    Y = APPLY_TRANSFORM(T, X) applies a linear transform specified in T
%    to each column of X to produce the corresponding column of Y. If X
%    is M-by-N then T must have M+1 columns and be of the
%    form [A, B] where B is a single column. If C is a column of X, the
%    corresponding column of Y is given by A*C + B.

xp = [x; ones(1, size(x,2))];
y = t * xp;

end
