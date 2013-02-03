function v = texture_vectors(im, maskstring, includemask1, smoothsize)
%TEXTURE_VECTORS returns the Laws texture vectors for an image
%   T = TEXTURE_VECTORS(IM) returns an array T of size [size(IM) N]
%   containing an N-element vector for each pixel of the image. The N
%   elements are the texture energies at that location found using Laws'
%   5x5 texture masks. N is equal to NMASKS*(NMASKS+1))/2-1 where NMASKS is
%   the number of 1-D masks specified. By default, 4 1-D masks are used
%   (the L5, E5, S5 and R5 masks), so N is 9, and the size of the
%   neighbourhood for smoothing the energies is 15. The mask formed from
%   the L5 x L5 outer product is not used.
%
%   T = TEXTURE_VECTORS(IM, MASKSTRING) allows the texture masks used to be
%   specified. See LAWS_MASKS for details of how the masks are specified.
%   The value [] for MASKSTRING is the same as omitting it. 
%
%   T = TEXTURE_VECTORS(IM, MASKSTRING, INCLUDEMASK1) specifies whether or
%   not the first mask returned by LAWS_MASKS is used. INCLUDEMASK should
%   be a logical value; the default is false, to omit the first mask, which
%   will normally be simply a smoothing mask. If INCLUDEMASK1 is true, N is
%   increased by 1.
%
%   T = TEXTURE_VECTORS(IM, MASKSTRING, INCLUDEMASK1, SMOOTHSIZE) allows
%   the size of the smoothing region for the texture energies to be
%   specified. SMOOTHSIZE must be a positive integer. Averages over
%   SMOOTHSIZE x SMOOTHSIZE regions are taken when the energies are
%   smoothed.
%
%   See also TEXTURE_SEGMENT, LAWS_MASKS, TEXTURE_DEMO

% David Young, School of Informatics, University of Sussex, 2009

% deal with arguments
if nargin < 4
    smoothsize = 15;
end
if nargin < 3
    includemask1 = false;
end
if nargin < 2
    maskstring = '';
end

masks = laws_masks(maskstring); 
nmasks1 = length(masks);
nmasks2 = nmasks1 ^ 2;
if includemask1
    firstmask = 1;
else
    firstmask = 2;
end

% Convolve the masks with the image
% We obtain one output array for each mask
convims = cell(nmasks1, nmasks1);
for i = firstmask:nmasks2
    convims{i} = convolve2(im, masks{i}, 'reflect');
end

% Square to get energies and smooth
% This produces one texture energy image for each mask. The smoothing means
% that the energy for a given pixel is actually a local average over it and
% its neighbours.
energyims = cell(nmasks1, nmasks1);
mask = ones(smoothsize);
for i = firstmask:nmasks2
    energyims{i} = convolve2(convims{i}.^2, mask, 'reflect');
end

% Combine symmetrical components
nenergies = (nmasks1*(nmasks1+1))/2 + (1-firstmask);  % final number of arrays
tims = cell(1, nenergies);
cindex = 0;

for i = 1:nmasks1
    for j = i:nmasks1
        if i == j
            if includemask1 || i > 1
                % masks on the diagonal are just copied
                cindex = cindex + 1;
                tims{cindex} = energyims{i,i};
            end
        else
            % masks off the diagonal are combined
            cindex = cindex + 1;
            tims{cindex} = (energyims{i,j}+energyims{j,i})/2;
        end
    end
end

% Convert cell array of energy matrices to set of vectors
v = zeros([size(im) nenergies]);   % A 3-D array
for i = 1:length(tims)
    v(:,:,i) = tims{i}; % Copy the separate energy matrices
end

end
