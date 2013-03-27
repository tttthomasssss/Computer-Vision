function thresh_img = thresholding(img, greater_than, less_than)

    thresh_img = (img > greater_than) & (img < less_than);