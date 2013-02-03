function [r, c] = default_features(i)
%DEFAULT_FEATURES returns pre-computed set of features for chessboard image
%   [R, C] = DEFAULT_FEATURES(I) looks up the image I and if it is one it
%   knows about, returns the row and column indices of a set of feature
%   points that might be used for correspondence matching.
load savedFeatures
i = find([savedFeatures.hash] == simplehash(i));
if isempty(i)
    error('Unknown image - no stored features');
end
r = savedFeatures(i).rows;
c = savedFeatures(i).cols;
end

function x = simplehash(i)
x = sum(sum(i(1:10:end, 1:10:end)));
end
