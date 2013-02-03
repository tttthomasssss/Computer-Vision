function d = orientation_diff(a1, a2)
%ORIENTATION_DIFF Difference between two orientations
%    D = ORIENTATION_DIFF(A1, A2) Calculates the angular difference
%    between line orientations in degrees as returned by REGIONPROPS.
d = mod(a2-a1+90, 180)-90;
end
