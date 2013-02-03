function g = getgreymaxima(x)
% GETGREYMAXIMA returns the local maxima in a grey-level image.
%	G = GETGREYMAXIMA(IMAGE) returns a matrix G equal in size to the
%	matrix IMAGE, with 0 everwhere except at positions where the value in
%	IMAGE is no less than any of its 8 neighbours.
%
%	No maxima are recorded for boundary positions with less than 8
%	neighbours.
%
%   This function is faster than imregionalmax (in release 2010a), though
%   it will not give the same results at the boundaries or if there are
%   plateaux in the array.

% Copyright David Young 2010
 
% This is faster than using colfilt on 3x3 regions.
g = zeros(size(x));
r = 2:size(x,1)-1;
c = 2:size(x,2)-1;
z = x(r,c);
g(r,c) = z >= x(r-1,c-1) & z >= x(r-1,c) & z >= x(r-1,c+1) ...
       & z >= x(r,c-1)            &        z >= x(r,c+1) ...
       & z >= x(r+1,c-1) & z >= x(r+1,c) & z >= x(r+1,c+1);
   
end

