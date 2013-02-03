function [newxs, newys] = snake_interp(xs, ys, n, stepsize)
%SNAKE_INTERP Interpolate control points round an existing snake
%   [NEWXS, NEWYS] = SNAKE_INTERP(XS, YS, N) takes vectors of x- and y-
%   coords and returns updated vectors with N points, equally spaced by
%   interpolation in the original vectors.
%   [NEWXS, NEWYS] = SNAKE_INTERP(XS, YS, N, STEPSIZE) ignores N and
%   generates enough points to make the distance between neighbours equal
%   to approximately STEPSIZE.

% get original step lengths
xr = [xs(end); xs(1:end-1)];        % shifted right one place
yr = [ys(end); ys(1:end-1)];        % shifted right one place
stepsizes = sqrt((xs-xr).^2 + (ys-yr).^2);
cumlen = cumsum(stepsizes);         % positions along snake
len = cumlen(end);

% get new no. points
if nargin == 4
    n = round(len / stepsize);
end

% scale old positions as if snake length was n
cumlen = (n/len) * cumlen;
cumlen(end) = n;      % ensure no rounding error here

% for each new point, get the index of the original point that is
% next after it in the snake
nexti = zeros(n,1);
i = 1;
for j = 1:n
    while j > cumlen(i)
        i = i+1;
    end
    nexti(j) = i;
end

% do the interpolation. f is fraction of old step at which new pt falls
f = (len/n) * (cumlen(nexti) - (1:n)') ./ stepsizes(nexti);
fc = 1 - f;
newxs = xr(nexti) .* f + xs(nexti) .* fc;
newys = yr(nexti) .* f + ys(nexti) .* fc;

end
