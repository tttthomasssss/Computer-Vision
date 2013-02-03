function r = rotation_matrix(u, theta)
% ROTATION_MATRIX computes a 3-D rotation matrix from a vector and an angle.
%   R = ROTATION_MATRIX(U, THETA) returns an orthonormal matrix R,
%   representing the rotation by angle THETA about the vector U.
%   See Wikipedia entry for "Rotation Matrix"

u = u/norm(u);
c = cos(theta); s = sin(theta); C = 1-c;
x = u(1); y = u(2); z = u(3);
xC = x*C; yC = y*C; zC = z*C;
xs = x*s; ys = y*s; zs = z*s;
xyC = x*yC; zxC = z*xC; yzC = y*zC;
r = [x*xC+c  xyC-zs  zxC+ys; ...
     xyC+zs  y*yC+c  yzC-xs; ...
     zxC-ys  yzC+xs  z*zC+c];
end
     
