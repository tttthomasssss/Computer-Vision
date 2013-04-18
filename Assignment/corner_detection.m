function correspondences = corner_detection(img_right, img_left)
 
    % Apply Filters
    h = fspecial('gauss', [11 2]);
    
    for i = 1:200
        img_left = imfilter(img_left, h, 'replicate');
        img_right = imfilter(img_right, h, 'replicate');
    end;
    
    corners_left = corner(img_left);
    corners_right = corner(img_right);
    
    % Extract Region Patches
    rd = RegionDetector();

    corner_bins_left = rd.cluster_corners(corners_left);
    corner_bins_right = rd.cluster_corners(corners_right);

    corner_bbs_left = rd.extract_bounding_box_patches_from_corner_clusters(corner_bins_left, img_left);
    corner_bbs_right = rd.extract_bounding_box_patches_from_corner_clusters(corner_bins_right, img_right);

    % Match Features
    corr_factory = CorrespondenceFactory(img_right, img_left);

    correspondences = corr_factory.match_corners(corner_bbs_right, corner_bbs_left);