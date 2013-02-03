function [r,c,v] = findpeaks(x)
%FINDPEAKS Finds the local maxima of an array.
%    [R,C,V] = FINDPEAKS(X) returns the row and column coordinates and
%    the values of the local maxima of the 2-D array X. R(I), C(I) and
%    V(I) are respectively the row, column and value of the I'th local
%    maximum.
%
%    A local maximum is an array element which is no less than any of its
%    8 neighbours. Boundary elements are not maxima.

% Copyright David Young 2010

g = getgreymaxima(x);
[r,c,v] = find(g .* x);

end
