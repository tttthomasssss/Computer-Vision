function [r, c] = simple_features(im, sigma, thresh)
%SIMPLE_FEATURES demonstrates feature finding
%     [R, C] = SIMPLE_FEATURES(IM) takes a grey-level image as an argument,
%     and returns two column vectors R and C of the same length. R(I) and
%     C(I) give the row and column of the I'th feature in the image.
%
%     [R, C] = SIMPLE_FEATURES(IM, SIGMA, THRESH) allows the parameters of
%     the process to be set. SIGMA is the width parameter for the
%     Laplacian-of Gaussian and THRESH is the threshold for peak/trough
%     detection - see below.
%
%     F = SIMPLE_FEATURES(...) returns a single 2xN matrix with the x
%     coordinates as the first row and the y coords as the second row. Thus
%     F = [C, R]'.
%
%     This adopts a very simple approach for demonstration purposes, and
%     can be improved on substantially. We simply convolve with a
%     Laplacian-of-Gaussian mask to fix the scale and to work with
%     contrasts rather than absolute grey levels. We then find local maxima
%     and minima, retaining only those that exceed a fixed threshold. They
%     are then put together into a single set of features.

% These defaults allows the function to be called with 1 argument so that
% it conforms to the specification on the course web pages
if nargin < 2
    sigma = 10;     % spatial smoothing scale
end
if nargin < 3
    thresh = 0.5;   % threshold for peak size (as a fraction of max peak)
end

% Convolution step
hsize = round(5*sigma);   % half the size of the mask (minus 1)
m = fspecial('log', hsize*2+1, sigma);  % get the mask
c = convolve2(im, m, 'valid');

% Peak finding stage
[r1, c1, v] = findpeaks(c);  % findpeaks gets local maxima
i1 = v > (max(v)*thresh);    % find which ones exceed threshold
[r2, c2, v] = findpeaks(-c); % now local minima
i2 = v > (max(v)*thresh);    % and which of these exceed threshold

% Final output construction. Indexing by i1 and i2 selects the peaks that
% were above threshold. We concatenate the positions of the positive and
% negative peaks. Adding hsize corrects for the fact that hsize pixels were
% lost off the edge of the original image when the 'valid' convolution
% output was obtained.
r = [r1(i1); r2(i2)] + hsize;
c = [c1(i1); c2(i2)] + hsize;

% Combine if only one output required
if nargout < 2
    r = [c r]';
end

end