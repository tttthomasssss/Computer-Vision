function norm_matrix = normalise_matrix(matrix, max_range, min_range)

    [xmax loc] = max(matrix(:));
    [xmin loc] = min(matrix(:));

    temp_matrix = matrix - xmin;
    
    temp_matrix = temp_matrix * ((max_range - min_range) / (xmax - xmin)) + min_range;
    
    norm_matrix = temp_matrix;        