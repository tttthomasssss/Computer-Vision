function correspondences = snake_detection(img_right, img_left)
    
    % Apply Filter
    h = fspecial('gauss', [5 5]);
    
    img_left = imfilter(img_left, h);
    img_left = imfilter(img_left, h);

    img_right = imfilter(img_right, h);
    img_right = imfilter(img_right, h);
    
    
    %% Extract Dark Stuff
    % Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
    dil_map_left = img_left < 0.15;
    dil_map_right = img_right < 0.15;
    
    % Extract Bounding Boxes
    rd = RegionDetector();

    boxes_left = rd.detect_bounding_boxes(dil_map_left);
    boxes_right = rd.detect_bounding_boxes(dil_map_right);
    
    % Create Snake
    sf = SnakeFactory(Consts.DFLT_NUM_CONTROL_POINTS, 1, .01);
    snake_list_left = sf.init_and_fit_snakes(img_left, boxes_left);
    snake_list_right = sf.init_and_fit_snakes(img_right, boxes_right);

    corr_factory = CorrespondenceFactory(img_right, img_left);
    correspondences = corr_factory.match_snakes(snake_list_right, boxes_right, snake_list_left, boxes_left);
    
    %% Extract very bright stuff
    thresh_img = thresholding(img_left, 0.9, 0.95);
    img_left = img_left + 2 * thresh_img;
    dil_map_left = img_left > 1;

    thresh_img = thresholding(img_right, 0.9, 0.95);
    img_right = img_right + 2 * thresh_img;
    dil_map_right = img_right > 1;
    
    % Extract Bounding Boxes
    boxes_left = rd.detect_bounding_boxes(dil_map_left);
    boxes_right = rd.detect_bounding_boxes(dil_map_right);
    
    % Create Snake
    snake_list_left = sf.init_and_fit_snakes(img_left, boxes_left);
    snake_list_right = sf.init_and_fit_snakes(img_right, boxes_right);
    
    correspondences = [correspondences corr_factory.match_snakes(snake_list_right, boxes_right, snake_list_left, boxes_left)];
    
    %% Reasonably bright stuff
    thresh_img = thresholding(img_left, 0.82, 0.88);
    img_left = img_left + 2 * thresh_img;
    dil_map_left = img_left > 1;

    thresh_img = thresholding(img_right, 0.82, 0.88);
    img_right = img_right + 2 * thresh_img;
    dil_map_right = img_right > 1;
    
    % Extract Bounding Boxes
    boxes_left = rd.detect_bounding_boxes(dil_map_left);
    boxes_right = rd.detect_bounding_boxes(dil_map_right);
    
    % Create Snake
    snake_list_left = sf.init_and_fit_snakes(img_left, boxes_left);
    snake_list_right = sf.init_and_fit_snakes(img_right, boxes_right);
    
    correspondences = [correspondences corr_factory.match_snakes(snake_list_right, boxes_right, snake_list_left, boxes_left)];
    