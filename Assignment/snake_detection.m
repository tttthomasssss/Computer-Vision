close all;

df = DataFactory();
img = df.img_left_bw;
% Smooth the threshed image a bit
%h = fspecial('average', [5 5]);
%thresh_img = filter2(h, thresh_img);

%img = df.dilate_grayscale_img(df.img_left_bw, 2, 'diamond', 3);

figure(1);
imshow(img);

% Luke, the DARK side is stronger!
dil_map = img < 0.15;

cc = bwconncomp(dil_map);

figure(2);
imshow(df.img_left_bw);

for i = 1:cc.NumObjects
    [idx_rows idx_cols] = ind2sub(size(thresh_img), cc.PixelIdxList{1, i});

    min_col = min(idx_cols);
    max_col = max(idx_cols);
    min_row = min(idx_rows);
    max_row = max(idx_rows);

    height = max_row - min_row;% + 1;
    width = max_col - min_col;% + 1;

    % Don't bother about a box in case its region is less than 30x30 Pixel
    if max_row - min_row > 30 && max_col - min_col > 30
 
        figure(2);
        rectangle('Position', [min_col, min_row, width, height], 'LineWidth', 1, 'EdgeColor', 'r');
        
        % Go for snakes here!!!
        sf = SnakeFactory(30, df.img_left_bw, [min_col, min_row, width, height]);
    end;
end;