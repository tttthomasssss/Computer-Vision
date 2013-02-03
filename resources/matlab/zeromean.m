function y = zeromean(x)
%ZEROMEAN subtracts the mean of its argument from each element

y = x - mean(x(:));
end
