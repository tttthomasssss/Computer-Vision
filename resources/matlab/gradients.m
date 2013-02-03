function [xg, yg, tg] = gradients(image1, image2, sigma)
%GRADIENTS Estimate spatial and temporal grey-level gradients
%   [XG, YG] = GRADIENTS(IMAGE, SIGMA) smooths the image with Gaussian
%   of width SIGMA, then convolves it with horizontal and vertical
%   centred differencing masks to get XG and YG respectively.
%
%   [XG, YG, TG] = GRADIENTS(IMAGE1, IMAGE2, SIGMA) estimates the spatial
%   gradients of the average image (as above) and also the temporal
%   gradient by smoothing the difference of the two images.
%
%   The output arrays are the same size as the input arrays, but the
%   results within about SIGMA of the boundary will be unreliable because
%   of edge effects. The 'reflect' option to CONVOLVE2 is used to keep the
%   sizes the same.

if nargin == 2
    sigma = image2;
    av = image1;
else
    av = 0.5 * (image1+image2);
end

% Gaussian mask. The mask is quite a generous size which ensures the
% values at the edge of the mask are small
smask = fspecial('gaussian', 2*ceil(2.6*sigma)+1, sigma);

% Use 'reflect' to keep the output same size as input.
smth = convolve2(av, smask, 'reflect');

% Hor and vert masks - use [1 0 -1]/2 to get the average gradient
% over 2 pixels
xg = convolve2(smth, [0.5, 0, -0.5], 'reflect');
yg = convolve2(smth, [0.5; 0; -0.5], 'reflect');

% Temporal difference
if nargin == 3
    tg = convolve2(image2-image1, smask, 'reflect');
end

end
    
