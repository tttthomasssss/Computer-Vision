function [r,c] = getfeatures(im, patchsize, relthresh)
%GETFEATURES  Get set of distinctive points in image
%    [R,C] = GETFEATURES(IM, PATCHSIZE, RELTHRESH) returns the row and
%    column coords of a set of points in the image IM which can be used as
%    a set of features for matching.
%
%    PATCHSIZE is the size of the square regions to be used for
%    comparisons. RELTHRESH is a relative threshold in the range 0 to 1,
%    such that 0 accepts all points, and increasing it towards 1 accepts
%    only points that have high salience.
%
%    This implementation selects features on the basis of local variance.
%    The variance for each square patch is found and features are local
%    maxima of variance where it exceeds RELTHRESH * (the maximum
%    variance).
% 
%    This function is now trivial, as it only has to call varPeaks.
%    Retained to avoid having to update other functions that call it, and
%    to allow the possibility of slotting in other methods in future.

% Copyright David Young 2010

[r,c] = varPeaks(im, patchsize, relthresh);

end
