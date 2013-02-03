function y = line_centres(x)
%LINE_CENTRES Return centre points of line segments
%
%    Y = LINE_CENTRES(X) computes the centre points of the line segments
%    represented by the matrix X. Each column of X holds the end points
%    of a line segment in the order [X1; Y1; X2; Y2]. If X is 4xN, Y is
%    2xN and each column holds a centre point as [X;Y].

% David Young, March 2002
% Copyright (c) University of Sussex

y = [(x(1,:)+x(3,:))/2;  (x(2,:)+x(4,:))/2];

end
