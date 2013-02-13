function img = feature_detection(image)
    
    % Hardcoded for the chess1.bmp image
    conv_mask = image(255:285, 286:322);
    
    % Convolve
    conv_img = convolve2(image, conv_mask, 'valid');
    
    img = normalise_matrix(conv_img, 1, 0);
    
    