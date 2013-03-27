close all;

img_left_bw = teachimage('assignment/img_left_gray.bmp');
img_left_col = teachimage('assignment/img_left_colour.tif');

% Dilate before thresholding
df = DataFactory();

dil_img = df.dilate_grayscale_img(img_left_bw, 3, 'square', 2);

thresh_img = thresholding(dil_img, 0.7, 0.75);

%thresh_img = thresh_img * 5;

figure(1);
imshow(dil_img);

add_img = dil_img + img_left_bw;

figure(2);
imshow(add_img);