close all;

%{
img_left_bw = teachimage('assignment/img_left_gray.bmp');
img_left_col = teachimage('assignment/img_left_colour.tif');
img_right_bw = teachimage('assignment/img_right_gray.bmp');

bw = im2bw(img_left_col, graythresh(img_left_col));
[B L] = bwboundaries(bw, 'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on;
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
end;
%}

