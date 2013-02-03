function lines = interp_show(lines, col, showlabel)
%INTERP_SHOW Display lines for interpretation tree demo
%    LINES = INTERP_SHOW(LINES, COL, SHOWLABEL) draws or updates lines in
%    the current figure. LINES is a data structure as returned by
%    INTERP_READ. COL is a string giving the colour to use; defaults to
%    black. SHOWLABEL is 1 to put labels beside the lines, 0 otherwise;
%    defaults to 1. The result is a copy of the first argument with only
%    the handles possibly changed.
%
%    If a line has already been drawn, it is not redrawn in a new
%    window or position - only its colour can be changed.
%
%    If COL is empty, the line is deleted.
%
% See also INTERP_DEMO, INTERP_READ

% David Young, March 2002
% Copyright (c) University of Sussex

if nargin < 3; showlabel = 1; end
if nargin < 2; col = 'k'; end

for i = 1:length(lines)  % Have to update structure
    lines(i) = showline(lines(i), col, showlabel);
end
drawnow;

end

% ---------------------------------------------------------------------

function lin = showline(lin, col, showlabel)

if isempty(col)
    if ~isempty(lin.handle)
        delete(lin.handle);
        lin.handle = [];
    end
else
    if isempty(lin.handle)
        if strcmp(lin.type, 'm')
            subplot(1,2,1);
            title('Model lines');
            interp_axes;
        elseif strcmp(lin.type, 'i')
            subplot(1,2,2);
            title('Image lines');
            interp_axes;
        end
        l = lin.linedata;
        lin.handle = line(l([1,3]), l([2,4]), 'Color', col);
        if showlabel
            label(lin);
        end
    else
        set(lin.handle, 'Color', col);
    end
end

end

% ---------------------------------------------------------------------

function label(lin)
% Write the line's name beside it

if strcmp(lin.type, 'm')
    name = char('a' - 1 + lin.name);
else
    name = int2str(lin.name);
end

% draw it now so can find how big text is
h = text(0,0, name, 'Visible','off', ...
    'HorizontalAlignment','center', 'VerticalAlignment','middle');
e = get(h, 'Extent');
r = 0.5 * max(e(3), e(4));  % approx radius of character

% Get offset centre position of line
l = lin.linedata;
c = line_centres(l);
v = l(1:2) - l(3:4);        % vector along line
v = v / sqrt(v'*v);        % unit vector along line
v = [-v(2); v(1)];         % normal unit vector
p = c + r * v;             % offset centre

% Move the name so it does not lie on top of the line
set(h, 'Position', p', 'Visible','on');

% Draw a little tick mark on the line pointing to label
d = c + 0.4*r*v;
line([c(1), d(1)], [c(2), d(2)]);

end
