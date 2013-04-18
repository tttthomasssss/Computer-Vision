function correspondences = quadtree_detection(img_right, img_left)

    % Apply Filters
    h = fspecial('gauss', [5 5]);

    img_left = imfilter(img_left, h);
    img_left = imfilter(img_left, h);

    img_right = imfilter(img_right, h);
    img_right = imfilter(img_right, h);

    % Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
    dil_map_left = img_left < 0.15;
    dil_map_right = img_right < 0.15;
    
    % Extract Bounding Boxes
    rd = RegionDetector();

    boxes_left = rd.detect_bounding_boxes(dil_map_left);
    boxes_right = rd.detect_bounding_boxes(dil_map_right);

    qf = QuadtreeFactory();
    trees_left = qf.init_quadtrees(boxes_left, img_left);
    trees_right = qf.init_quadtrees(boxes_right, img_right);

    corr_factory = CorrespondenceFactory(img_right, img_left);
    correspondences = corr_factory.match_quadtrees(trees_right, trees_left);