function correspondences = line_detection(img_right, img_left)
    % Morph Left Image
    h = fspecial('gauss', [5 5]);
    img_left = imfilter(img_left, h, 'replicate');
    for i = 1:130
        img_left = imfilter(img_left, h, 'replicate');
    end;

    % Morph Right Image
    img_right = imfilter(img_right, h);
    for i = 1:130
        img_right = imfilter(img_right, h, 'replicate');
    end;
    
    % Create Edge Maps & Do Hough Transform
    edge_map_left = edge(img_left, 'canny');
    edge_map_left = bwmorph(edge_map_left, 'dilate');

    edge_map_right = edge(img_right, 'canny');
    edge_map_right = bwmorph(edge_map_right, 'dilate');

    lf = LineFactory();
    lines_left = lf.retrieve_hough_lines(edge_map_left);
    lines_right = lf.retrieve_hough_lines(edge_map_right);

    % Match Features
    corr_factory = CorrespondenceFactory(img_right, img_left);

    correspondences = corr_factory.match_lines(lines_right, lines_left);