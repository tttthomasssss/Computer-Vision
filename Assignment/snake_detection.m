close all;

df = DataFactory();
img = df.img_left_bw;
% Smooth the threshed image a bit
h = fspecial('gauss', [5 5]);
thresh_img = filter2(h, img);

%img = df.dilate_grayscale_img(df.img_left_bw, 1, 'diamond', 3);
img = imfilter(df.img_left_bw, h);
img = imfilter(img, h);

thresh_img = thresholding(img, 0.68, .78);
thresh_img = img + (2 * thresh_img);

figure(7878);
imshow(thresh_img);

edge_map = edge(df.img_left_bw, 'canny');
edge_map = bwmorph(edge_map, 'dilate');
%edge_map = bwmorph(edge_map, 'dilate');

figure(567);
imshow(edge_map);

figure(1);
imshow(img);

% Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
dil_map = img < 0.15;

figure(666);
imshow(dil_map);

%thresh_img = img - (2 * dil_map);
%figure(667);
%imshow(thresh_img);

%dil_map = bwmorph(dil_map, 'erode');
%dil_map = bwmorph(dil_map, 'erode');
%figure(667);
%imshow(dil_map);

rd = RegionDetector();

boxes = rd.detect_bounding_boxes(dil_map);

[rows cols] = size(boxes);
figure(2);
imshow(df.img_left_bw);

for i = 1:rows
    figure(2);
    rectangle('Position', boxes(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

sf = SnakeFactory(Consts.DFLT_NUM_CONTROL_POINTS, 1, .01);
snake_list = sf.init_and_fit_snakes(img, boxes);

figure(3);
imshow(df.img_left_bw);

for i = 1:length(snake_list)
    figure(3); hold on;
    snake = snake_list{i};
    plot(snake(:, 2), snake(:, 1), 'Marker', 'o', 'Color', 'g');
end;

c = Corresponder();

c.match_regions(df.img_left_bw, snake_list, df.img_right_bw);

% Get Connected Regions from the dilated map
%cc = bwconncomp(dil_map);

% Get Connected Regions from the edgemap
%thresh_img = thresh_img > 0.96;
%cc = bwconncomp(thresh_img);

% THIS STUFF IS WORKING!!!!!!
%{
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
%}