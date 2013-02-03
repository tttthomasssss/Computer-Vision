function [c, x] = delete_col(x, i)
%DELETE_COL Separates a selected column from a matrix
%
%    [C, Y] = DELETE_COL(X, I) returns C, the I'th column of X, and Y,
%    the matrix X with its I'th column removed. Works with structure
%    matrices too.

c = x(:, i);
x(:, i) = [];

end
