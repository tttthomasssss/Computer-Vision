function thresh_img = thresholding(img, greater_than, less_than)
%THRESHOLDING Applies a certain threshold interval to a grayscale image
%
%THRESH_IMG = THRESHOLDING(IMG, GREATER_THAN, LESS_THAN) applies a
%threshold in the interval GREATER_THAN <= x <= LESS_THAN for IMG and
%returns the thresholded image
    thresh_img = (img > greater_than) & (img < less_than);