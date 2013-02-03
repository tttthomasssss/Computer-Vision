function ok = interp_test(m1, i1, matches, tol)
%interp_test Tests a line pair against previous matches
%
%    OK = INTERP_TEST(M1, I1, MATCHES, TOL) Tests whether the pairing of M1
%    with I1 is consistent with each pairing in MATCHES.
%
% See also INTERP_DEMO, INTERP_MATCH, TESTLINES

% David Young, March 2002
% Copyright (c) University of Sussex

ok = true;
for m = matches
    if ~testlines(m1, m(1), i1, m(2), tol)
        ok = false;
        break;
    end
end

end

function ok = testlines(m1, m2, i1, i2, tol)
%TESTLINES Test match between two pairs of lines
%
%    OK = TESTLINES(M1, M2, I1, I2, TOL) Returns 1 if angle between lines
%    M1 and M2 is within TOL of angle between lines I1 and I2, or if
%    either I1 or I2 is empty.
%
% See also INTERP_DEMO, LINE_ANGLE

% David Young, March 2002
% Copyright (c) University of Sussex

if isempty(m1) || isempty(i1)
    ok = true;
else
    am = line_angle(m1, m2);
    ai = line_angle(i1, i2);

    ok = abs(am-ai) < tol;
end

end

function a = line_angle(lin1, lin2)
%LINE_ANGLE Angle between two line segments
%
%    A = LINE_ANGLE(L1, L2) Returns angle A, unsigned and in range 0 to
%    pi/2, between two line segments, each represented as in INTERP_READ.
%
% See also INTERP_DEMO

% David Young, March 2002
% Copyright (c) University of Sussex

l1 = lin1.linedata;
l2 = lin2.linedata;
v1 = l1(1:2) - l1(3:4);
v2 = l2(1:2) - l2(3:4);
a1 = atan2(v1(2), v1(1));
a2 = atan2(v2(2), v2(1));
a = a1 - a2;        % signed angle
a = mod(a+pi, 2*pi) - pi;       % in range -pi to pi
a = abs(a);             % unsigned in range 0 to pi
if a > pi/2; a = pi - a; end      % in range 0 to pi/2

end

