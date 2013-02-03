function lines = interp_corrupt(lines, omit, extra, wobble)
%INTERP_CORRUPT Changes a set of lines for interpretation tree demo
%
%    NEWLINES = INTERP_CORRUPT(LINES, OMIT, EXTRA, WOBBLE) Rotates,
%    translates and scales a set of lines, given in the format set up by
%    INTERP_READ. Then messes them up by omitting OMIT of them, adding
%    EXTRA random lines and shifting the ends around by a random amount
%    given by WOBBLE. Finally shuffles their order.
%
%    Gives them new names and null handles.
%
%    The idea is a rough simulation of the effect of imaging an object
%    whose underlying structure corresponds to the input lines.
%
% See also INTERP_DEMO, INTERP_READ

% David Young, March 2002, 2009
% Copyright (c) University of Sussex

% Random line transformation
angle = 2*pi*rand;
c = cos(angle); s = sin(angle);
r = [c, s; -s, c];
scale = 0.7*rand + 0.5;
shift = 25 * rand(2, 1);
shift = [shift; shift];

for i = 1:omit
    [c, lines] = delete_col(lines, randi(length(lines))); %#ok<ASGLU>
end

for i = 1:length(lines)
    ln = lines(i);
    ld = ln.linedata;
    if wobble
        ld = ld + wobble * randn(4, 1);
    end
    ln.linedata = scale * rotate_line(ld, r) + shift;
    ln.type = 'i';      % it's an image line
    ln.handle = [];     % it's an undisplayed line
    lines(i) = ln;
end

for i = 1:extra
    lines = [lines, random_line(ln)];
end

lines = shuffle_cols(lines);

for i = 1:length(lines)
    lines(i).name = i;
end

end


function ln = random_line(ln)
% A random line segment. Assumes operational area [-100 100 -100 100]
% Input is just a template for the line structure.
p1 = 50 * randn(2, 1);
p2 = p1 + 25 * randn(2, 1);
ln.linedata = [p1; p2];

end


function ld = rotate_line(ld, r)
% Rotates the line segment about the origin, given
% the data matrix with the end points and a rotation matrix
p1 = r * ld(1:2);
p2 = r * ld(3:4);
ld = [p1; p2];

end
