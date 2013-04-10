%{
    Approach:
    
%}
close all;

df = DataFactory();

img = df.img_left_col;

figure; imshow(img(:, :, 1));
figure; imshow(img(:, :, 2));
figure; imshow(img(:, :, 3));

%figure; imshow()

[fff xxx] = imhist(img(:, :, 1));
disp(fff);
disp(xxx);
figure; imshow(fff);
figure; imhist(img(:, :, 2));
figure; imhist(img(:, :, 3));

disp(size(img));

