function edges = gaussian_edge_detection(image, hsize, sigma)

    gauss_conv_mask = fspecial('gauss', hsize, sigma);
    h_conv_mask = [1 -1];
    v_conv_mask = [1; -1];
    
    conv_img = convolve2(image, gauss_conv_mask, 'valid');
    conv_img = convolve2(conv_img, h_conv_mask, 'valid');
    conv_img = convolve2(conv_img, v_conv_mask, 'valid');
    
    conv_img = normalise_matrix(conv_img, 1, 0);
    
    imhist(conv_img);
    
    
    
    %imshow(conv_img)
    
    edges = conv_img;
    
    