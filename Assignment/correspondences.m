function corrs = correspondences(im1, im2)

    % Check if bw img, if not convert
    if ~is_binary_image(im1)
        t = graythresh(im1);
        im1 = im2bw(im1, t);
    end;
    
    if ~is_binary_image(im2)
        t = graythresh(im2);
        im2 = im2bw(im2, t);
    end;
    
    % Snake stuff
    corrs = snake_detection(im2, im1);
    
    % Quadtree Stuff
    corrs = [corrs quadtree_detection(im2, im1)];
    
    % Line Stuff
    corrs = [corrs line_detection(im2, im1)];
    
    % Corner Stuff
    corrs = [corrs corner_detection(im2, im1)];