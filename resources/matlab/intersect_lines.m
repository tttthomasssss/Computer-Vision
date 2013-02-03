function [x, y] = intersect_lines(t1, r1, t2, r2)
%INTERSECT_LINES Intersection of two lines
%   [X, Y] = INTERSECT_LINES(T1, R1, T2, R2) returns the coordinates of the
%   intersection of the two lines specified by the arguments. T1 and R1 are
%   the (angle, radius) polar coordinates of the point on one line
%   nearest to the origin; T2 and R2 likewise for the other line.
%   (Note that angle comes first, as in pol2cart and other Matlab functions
%   dealing with polar coordinates.)
%   
%   If R1 or R2 is zero, the corresponding T1 or T2 is taken to give the
%   orientation of the normal to the line.

% fiddly because we have to deal with lines that pass through the origin

if r1 == 0      % if we have a non-zero r, make sure it is r1
    [t1, r1, t2, r2] = deal(t2, r2, t1, r1);
end

if r2 == 0      % we have a zero r
    if r1 == 0      % in fact, both r's are zero, so trivial 
        x = 0; 
        y = 0;
    else            % r1 non-zero, but second line is through origin
        [x1, y1] = pol2cart(t1, r1);
        [x2, y2] = pol2cart(t2+pi/2, 1);    % unit vector along second line
        k = r1^2/(x1*x2+y1*y2);             % solve for radius of intersection         
        x = x2 * k;
        y = y2 * k;
    end
else            % normal case
    [x1, y1] = pol2cart(t1, r1);
    [x2, y2] = pol2cart(t2, r2);
    v = [x1 y1; x2 y2] \ [r1; r2].^2;   % solve linear equations for intersection
    x = v(1);
    y = v(2);
end

end
