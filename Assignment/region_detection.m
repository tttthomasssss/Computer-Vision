close all;

img_left_bw = teachimage('assignment/img_left_gray.bmp');
img_left_col = teachimage('assignment/img_left_colour.tif');

gauss_mask = fspecial('gauss', 11, 2);

%conv_img = convolve2(img_left_bw, gauss_mask, 'valid');

edges_img_left_bw = edge(img_left_bw, 'canny');

dilation_img_left_bw = bwmorph(edges_img_left_bw, 'dilate');
%dilation_img_left_bw = edges_img_left_bw;

figure(11);
imshow(conv_img);

%dilation_img_left_bw = 1 - dilation_img_left_bw;

%[labels8 num8] = bwlabel(dilation_img_left_bw, 8);
%[labels4 num4] = bwlabel(dilation_img_left_bw, 4);

%fprintf('Nr of connected objects 8mode: %d\n', num8);
%fprintf('Nr of connected objects 4mode: %d\n', num4);

CC = bwconncomp(dilation_img_left_bw);
l = labelmatrix(CC);

figure(2222);
imshow(label2rgb(l));

corners = corner(dilation_img_left_bw);

%figure(1);
%imshow(conv_img);

figure(1);
imshow(dilation_img_left_bw);
hold on;

%plot(corners(:,1), corners(:,2), 'r*');

for i = 1:CC.NumObjects
    [idx idy] = ind2sub(size(dilation_img_left_bw), CC.PixelIdxList{1, i});

    min_row = min(idy);
    max_row = max(idy);
    min_col = min(idx);
    max_col = max(idx);

    width = max_row - min_row + 1;
    height = max_col - min_col + 1;

    figure(1);
    rectangle('Position', [min_row, min_col, width, height], 'LineWidth', 1, 'EdgeColor', 'r');
end;
%img2 = 1 - dilation_img_left_bw;

%figure(222);
%imshow(img2);

%{
for i = 1:num8
    [r c] = find(labels8==i);

    min_row = min(r);
    max_row = max(r);
    min_col = min(c);
    max_col = max(c);

    width = max_col - min_col + 1;
    height = max_row - min_row + 1;

    figure(1);
    rectangle('Position', [min_row, min_col, width, height], 'LineWidth', 1, 'EdgeColor', 'r');
end;
%}

%vislabels(labels8);