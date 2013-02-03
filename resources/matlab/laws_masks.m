function masks = laws_masks(usemasks)
%LAWS_MASKS returns a set of 5x5 Laws' masks
%   MASKS = LAWS_MASKS returns a 4x4 cell array of the 5x5 Laws' masks
%   formed from the L5, E5, S5 and R5 1-D masks. LAWS_MASKS([]) does the
%   same.
%   MASKS = LAWS_MASKS('all') returns a 5x5 cell array with all the above
%   masks plus those involving the W5 1-D mask.
%   MASKS = LAWS_MASKS(S) returns an NMASKSxNMASKS cell array of masks,
%   where NMASKS is the length of the string S. S must only contain the
%   characters L, E, S, R and W and the result contains only the masks
%   formed from the specified components. The ordering of the masks in the
%   output array will correspond to the ordering of the characters in S, so
%   MASKS{I,J} will be the mask formed from the outer product of the 1-D
%   mask S(I) with the 1-D mask S(J).
%
%   For an explanation of the L5, E5, S5, R5 and W5 masks see any account
%   of Laws' method, for example
%   http://www.c3.lanl.gov/~kelly/notebook/laws.shtml
%
%   See also TEXTURE_VECTORS, TEXTURE_DEMO

%   David Young, 2009


% The commented-out code shows how the masks may be built from the simplest
% smoothing and differencing masks. We store the end results to reduce
% computation.
% Note that the 'full' convolution is needed to combine masks.
%
% L2 = [1 1]      % Simple smoothing mask
% E2 = [-1 1]     % Simple differencing mask
%
% % length 3 combinations of these
% L3 = convolve2(L2, L2, 'full')
% S3 = convolve2(E2, E2, 'full')
% E3 = convolve2(L2, E2, 'full')
%
% % and now all the length 5 combinations
% L5 = convolve2(L3, L3, 'full')
% E5 = convolve2(L3, E3, 'full')
% S5 = convolve2(L3, S3, 'full')  % same as E3 with E3
% R5 = convolve2(S3, S3, 'full')
% W5 = convolve2(S3, E3, 'full')

L5 = [ 1     4     6     4     1];
E5 = [-1    -2     0     2     1];
S5 = [ 1     0    -2     0     1];
R5 = [ 1    -4     6    -4     1];
W5 = [-1     2     0    -2     1];

% Put them into cell array to allow the use of a loop for the 2-D step
if nargin < 1 || isempty(usemasks)
    % Following some sources, we leave out W5 to reduce processing
    onedmasks = {L5 E5 S5 R5};
elseif isequal(usemasks, 'all')
    onedmasks = {L5 E5 S5 R5 W5};
else
    [ok, ind] = ismember(usemasks, 'LESRW');
    if ~all(ok)
           error(['Illegal mask identifier in ', usemasks]);
    end 
    allmasks = {L5 E5 S5 R5 W5};
    onedmasks = allmasks(ind);
end
nmasks1 = length(onedmasks);

% Generate the 2-D masks from pairs of 1-D masks. We rotate one of the pair
% to be vertical and convolve it with a horizontal mask (here implemented
% more efficiently using a matrix multiplication).
masks = cell(nmasks1, nmasks1);
for i = 1:nmasks1
    for j = 1:nmasks1
        masks{i,j} = (onedmasks{i})' * onedmasks{j};
    end
end

end
