function bool = is_power_of_2(n)
%IS_POWER_OF_2 determins whether n is a power of 2
    
    bool = (n ~= 0) && ((n & (n - 1)) == 0);

end

