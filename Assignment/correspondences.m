function corrs = correspondences(im1, im2)

    disp('correspondences - START...');
    
    % Check if bw img, if not convert
    if ~is_binary_image(im1)
        disp('Colour Image detected, will convert to grayscale image!');
        t = graythresh(im1);
        im1 = im2bw(im1, t);
        disp('Colour to grayscale conversion done!');
    end;
    
    if ~is_binary_image(im2)
        disp('Colour Image detected, will convert to grayscale image!');
        t = graythresh(im2);
        im2 = im2bw(im2, t);
        disp('Colour to grayscale conversion done!');
    end;
    
    disp('Starting Region Based Feature Extraction [Snakes, Quadtrees]...');
    
    % Snake stuff
    disp('(1 / 4) Starting Snake Feature matching...');
    corrs = snake_detection(im2, im1);
    disp('(1 / 4) Snake Feature matching finished!');
    
    % Quadtree Stuff
    disp('(2 / 4) Starting Quadtree Feature matching...');
    corrs = [corrs quadtree_detection(im2, im1)];
    disp('(2 / 4) Quadtree Feature matching finished!');
    
    disp('Region Based Feature Extraction Done!');
    disp('Starting Line Based Feature Extraction [Straight Lines, Corners]...');
    
    % Line Stuff
    disp('(3 / 4) Starting Line Feature matching...');
    corrs = [corrs line_detection(im2, im1)];
    disp('(3 / 4) Line Feature matching finished!');
    
    % Corner Stuff
    disp('(4 / 4) Starting Corner Feature matching...');
    corrs = [corrs corner_detection(im2, im1)];
    disp('(4 / 4) Corner Feature matching finished!');
    
    disp('Line Based Feature Extraction Done!');
    
    disp('correspondences - END!');