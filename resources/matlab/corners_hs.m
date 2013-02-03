function r = corners_hs(im, sigma, k)
% CORNERS_HS Simple implementation of the Harris-Stephens corner detector.
%     Y = CORNERS_HS(IM, SIGMA, K) expects a grey-level image IM, and
%     parameters SIGMA and K (see below). It returns a "corner response"
%     array which may then be thresholded, and local maxima found.
%
%     The detector is also known as the "Harris" or "Plessey" corner
%     detector. See: Harris, C. and Stephens, M. (1988) A combined corner
%     and edge detector, ACV88 Proceedings of the Fourth Alvey Vision
%     Conference, pp 147-151. The response is defined by:
% 
%                               2
%                 R = Det - k Tr
% 
%         where
%                             2
%                 Det = AB - C
%                 Tr = A + B
% 
%                      2
%                 A = X  * G(sigma)
%                      2
%                 B = Y  * G(sigma)
%                 C = (XY) * G(sigma)
% 
%                 X = I * Dx
%                 Y = I * Dy
% 
%     and where "*" means the convolution operation, Dx means the [-1 0 1]
%     mask and Dy its vertical equivalent, and G(sigma) means the Gaussian
%     smoothing mask with width parameter sigma.
% 
%     The arguments are:
% 
%     IM: the input image, a 2-D array containing numbers typically in the
%     range 0-1
% 
%     SIGMA: a positive number, the smoothing parameter
% 
%     K: a positive number, which controls sensitivity to edges or
%     corners. The best value for an application should be found
%     empirically - a reasonable starting point appears to be 0.04 for
%     images with grey levels in the range 0 to 1, but Harris and
%     Stephens fail to discuss this.
% 

X = convolve2(im, [-1, 0, 1], 'valid');
X = X(2:end-1, :);
Y = convolve2(im, [-1; 0; 1], 'valid');
Y = Y(:, 2:end-1);
XY = X .* Y;
X2 = X .* X;
Y2 = Y .* Y;

margin = round(sigma*2.575);    % reasonable truncation
gmask = fspecial('gauss', 2*margin+1, sigma);
A = convolve2(X2, gmask, 'valid');
B = convolve2(Y2, gmask, 'valid');
C = convolve2(XY, gmask, 'valid');
Tr = A + B;
R = (A .* B - C .* C) - k * Tr .* Tr;

r = zeros(size(im));
r(2+margin:end-1-margin, 2+margin:end-1-margin) = R;

end

