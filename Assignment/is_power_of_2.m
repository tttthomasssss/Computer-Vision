function bool = is_power_of_2(n)
%IS_POWER_OF_2 Summary of this function goes here
%   Detailed explanation goes here
    
    bool = (n ~= 0) && ((n & (n - 1)) == 0);

end

