%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
function bool = is_power_of_2(n)
%IS_POWER_OF_2 determins whether n is a power of 2
    
    bool = (n ~= 0) && ((n & (n - 1)) == 0);

end

