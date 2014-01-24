%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
function is_bin_img = is_binary_image(image)
%IS_BINARY_IMAGE determines whether the given image is a binary image
    is_bin_img = all(image(:) == 0 | image(:) == 1);