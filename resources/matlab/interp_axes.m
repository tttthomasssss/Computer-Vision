function interp_axes
%INTERP_AXES  Sets axes for interpretation tree demo
%    INTERP_AXES raises the current figure and sets axes with equal scales
%    to the ranges -100 to 100.
%
% See also INTERP_DEMO, INTERP_SHOW

% David Young, March 2002, 2009
% Copyright (c) University of Sussex

% Probably more efficient to check if this has already been called
% than to call the axis functions again.

str = 'Setaxes done';

if ~strcmp(str, get(gca, 'Userdata'))
    axis equal;
    axis([-100 100 -100 100]);
    set(gca, 'Userdata', str);
end

end
