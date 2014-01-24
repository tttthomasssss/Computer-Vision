%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
function edges = edge_detection(image, apply_smoothing, dark_threshold, light_threshold)

    % Horizontal & Vertical Differencing
    if apply_smoothing > 0
        h_diff_image = image;
        v_diff_image = image;
        for i = 1:apply_smoothing
            h_diff_image = h_diff_image(:, 1:end - 1) + h_diff_image(:, 2:end);
            v_diff_image = v_diff_image(1:end - 1, :) + v_diff_image(2:end, :);
        end;
    else
        h_diff_image = image(:, 1:end - 1) - image(:, 2:end);
        v_diff_image = image(1:end - 1, :) - image(2:end, :);
    end;
    
    % Normalisation & Thresholding
    h_diff_image = normalise_matrix(h_diff_image, 1, 0);
    h_bright_edges = h_diff_image > light_threshold;
    h_dark_edges = h_diff_image < dark_threshold;
    
    v_diff_image = normalise_matrix(v_diff_image, 1, 0);
    v_bright_edges = v_diff_image > light_threshold;
    v_dark_edges = v_diff_image < dark_threshold;
    
    % Combine, Crop & Combine
    h_all_edges = h_bright_edges | h_dark_edges;
    v_all_edges = v_bright_edges | v_dark_edges;
   
    [h_rows h_cols] = size(h_all_edges);
    [v_rows v_cols] = size(v_all_edges);
    
    min_rows = min(h_rows, v_rows);
    min_cols = min(h_cols, v_cols);
    
    h_all_edges = h_all_edges(1:min_rows, 1:min_cols);
    v_all_edges = v_all_edges(1:min_rows, 1:min_cols);
    
    edges = h_all_edges | v_all_edges;
    
    
    