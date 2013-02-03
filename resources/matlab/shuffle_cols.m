function y = shuffle_cols(x)
%SHUFFLE_COLS Shuffles the columns of a matrix at random
%
%    Y = SHUFFLE_COLS(X) returns its argument with the columns shuffled
%    into a random order.

if isa(x, 'double')
    y = zeros(size(x));
end

for n = size(x, 2) : -1 : 1
    [c, x] = delete_col(x, randi(n));
    y(:, n) = c;
end

end
