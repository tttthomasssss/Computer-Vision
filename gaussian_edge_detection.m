function edges = gaussian_edge_detection(image, hsize, sigma, thresh_const)

    % Init Convolusion Masks
    gauss_conv_mask = fspecial('gauss', hsize, sigma);
    h_conv_mask = [1 -1];
    v_conv_mask = [1; -1];
    
    % Convolve
    conv_img = convolve2(image, gauss_conv_mask, 'valid');
    
    h_conv_img = convolve2(conv_img, h_conv_mask, 'valid');
    v_conv_img = convolve2(conv_img, v_conv_mask, 'valid');
    
    % Normalise, apply Threshold & recombine bright and dark edges
    h_conv_img = normalise_matrix(h_conv_img, 1, 0);
    h_thresh = thresh_const * max(h_conv_img(:));
    h_bright_edges = h_conv_img > h_thresh;
    h_dark_edges = h_conv_img < (1 - h_thresh);
    
    h_all_edges = h_bright_edges | h_dark_edges;
    
    v_conv_img = normalise_matrix(v_conv_img, 1, 0);
    v_thresh = thresh_const * max(v_conv_img(:));
    v_bright_edges = v_conv_img > v_thresh;
    v_dark_edges = v_conv_img < (1 - v_thresh);
    
    v_all_edges = v_bright_edges | v_dark_edges;
    
    % Crop & Recombine all h and v edges
    [h_rows h_cols] = size(h_all_edges);
    [v_rows v_cols] = size(v_all_edges);
    
    min_rows = min(h_rows, v_rows);
    min_cols = min(h_cols, v_cols);
    
    edges = h_all_edges(1:min_rows, 1:min_cols) | v_all_edges(1:min_rows, 1:min_cols);
    
    