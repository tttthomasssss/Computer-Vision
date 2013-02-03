function v = homography_matrix(u, theta, t, f)
% HOMOGRAPHY_MATRIX returns homography matrix for view of points in a plane
%   V = HOMOGRAPHY_MATRIX(U, THETA, T, F) returns a 3*x matrix that
%   transforms homogenous coordinates of points in a plane into homogeneous
%   coordinates of points in an image of it.
%   The camera is rotated relative to the plane about an axis U and with
%   angle THETA, and then translated by T. Its focal length is F.

r = rotation_matrix(u, theta);
v = [f*r(1:2, 1:2) f*t(1:2); r(3, 1:2) t(3)];
end