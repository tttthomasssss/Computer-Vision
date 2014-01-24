%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
function img = feature_detection(image)
    
    % Hardcoded for the chess1.bmp image
    conv_mask = image(255:325, 286:322);
    
    %templ = flipud(conv_mask);
    %templ = rot90(conv_mask);
    %templ = rot90(templ);
    templ = rot90(rot90(conv_mask));
    
    % Convolve
    conv_img = convolve2(image, templ, 'valid');
    img = normalise_matrix(conv_img, 1, 0);
    
    