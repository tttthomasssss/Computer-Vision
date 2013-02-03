function [t, m] = bestThresh(sa, sb, w)
%bestThresh returns the best threshold for two sets of real scores
%   T = bestThresh(SA, SB) takes two real vectors of scores and finds the
%   threshold T that best discriminates the two classes A and B which
%   generated the scores, assuming that class A tends to generate lower
%   scores than class B.
%
%   More exactly, a score S is assigned to class A if S <= T and to class B
%   if S > T. The function finds a value T such that the average fraction
%   of correct assignments
%
%     (fraction of scores in SA assigned to class A 
%    + fraction of scores in SB assigned to class B) / 2
%
%   is a maximum. Unless there are repeated scores or the best threshold is
%   outside the range of the scores, T will be placed half way between two
%   scores.
%
%   T = bestThresh(SA, SB, W) allows weights to be given to the two
%   datasets. W must be a 2-element vector, and the quantity maximised is
%
%     W(1) * fraction of scores in SA assigned to class A 
%   + W(2) * fraction of scores in SB assigned to class B
%
%   To maximise the total number of scores correctly assigned, use
%
%       bestThresh(SA, SB, [length(SA) length(SB)]);
%
%   [T, M] = bestThresh(...) returns in M the quantity that has been
%   maximised. If W is omitted, this will lie between 0.5 and 1.0.
%
%   If SA and SB are matrices, they must have the same number of columns,
%   and the threshold and separation measure for each pair of columns
%   SA(:,k) and SB(:,k) is computed. The results are row vectors each with
%   one entry for each input column.

% David Young, January 2010

% Sort out and check arguments
error(nargchk(2, 3, nargin));
if nargin < 3
    wa = 0.5;
    wb = 0.5;
else
    wa = w(1);
    wb = w(2);
end
if size(sa, 1) == 1 % it's a row vector
    sa = sa';
end
if size(sb, 1) == 1 % it's a row vector
    sb = sb';
end

nsets = size(sa,2);
if size(sb,2) ~= nsets % different number of cols
    error('bestThresh:badsize', 'Different numbers of columns');
end

Na = size(sa, 1);
Nb = size(sb, 1);
if Na == 0 || Nb == 0
    error('bestThresh:emptydata', 'Empty dataset');
end


% Set up overall scores and class assignment matrices. It is important for
% class B to come first as otherwise repeated values may be split on
% opposite sides of the threshold. This solution relies on sort's
% documented behaviour of keeping the indices for repeated values in the
% original order.
scores = [sb; sa];
classes = zeros(size(scores));
classes(1:Nb, :) = -wb / Nb;
classes(Nb+1:end, :) = wa / Na;

% Sort scores, and do corresponding sort of class assignments
[scores, ind] = sort(scores);
linind = sub2ind(size(classes), ind, repmat(1:nsets, Na+Nb, 1));
classes = classes(linind); 

% Add rows to allow for thresholds outside range of scores
scores  = [scores(1,:)-1;      scores;   scores(end,:)+1];
classes = [repmat(wb,1,nsets); classes;  -ones(1,nsets)];

% Cumulated class assignments give the sum of the fractions of correctly
% assigned points for every threshold
[m, ind] = max(cumsum(classes));
linind = sub2ind(size(scores), ind, 1:nsets);
t = 0.5*(scores(linind) + scores(linind+1));

end
