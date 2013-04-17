function next = get_next_power_of_2(n)
%GET_NEXT_POWER_OF_2 Summary of this function goes here
%   Detailed explanation goes here
    
    c = 1;
    
    while (2 ^ c < n)
        c = c + 1;
    end;
    
    next = 2 ^ c;
end

