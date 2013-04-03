function is_bin_img = is_binary_image(image)
    is_bin_img = all(image(:) == 0 | image(:) == 1);