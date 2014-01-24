%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
function result = ternary_conditional(condition, a, b)
%TERNARY_CONDITIONAL evaluated condition, returns a in case condition == 1,
%b otherwise
%
% RESULT = TERNARY_CONDITIONAL(CONDITION, A, B) returns A in case CONDITION
% evaluates to 1 and B otherwise
    if condition
        result = a;
    else
        result = b;
    end
end