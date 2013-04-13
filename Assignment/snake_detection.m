close all;

%
%{
Look for Dark Features on both images and then try to relate them to the
dark features found in the other picture

do the same for light features
%}

df = DataFactory();
img = df.img_left_bw;
% Smooth the threshed image a bit
h = fspecial('gauss', [5 5]);
thresh_img = filter2(h, img);

%img = df.dilate_grayscale_img(df.img_left_bw, 1, 'diamond', 3);
img = imfilter(df.img_left_bw, h);
img = imfilter(img, h);

img_right = imfilter(df.img_right_bw, h);
img_right = imfilter(img_right, h);
dil_map_right = img_right < 0.15;

% thresh_img = thresholding(img, 0.68, .78);
% thresh_img = img + (2 * thresh_img);

% figure(7878);
% imshow(thresh_img);

edge_map = edge(df.img_left_bw, 'canny');
edge_map = bwmorph(edge_map, 'dilate');

%edge_map = bwmorph(edge_map, 'dilate');

% figure(567);
% imshow(edge_map);

% figure(999);
% imshow(img);

% Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
dil_map = img < 0.15;

figure(666);
imshow(dil_map);

figure(6666);
imshow(dil_map_right);
%thresh_img = img - (2 * dil_map);
%figure(667);
%imshow(thresh_img);

%dil_map = bwmorph(dil_map, 'erode');
%dil_map = bwmorph(dil_map, 'erode');
%figure(667);
%imshow(dil_map);

rd = RegionDetector();

boxes = rd.detect_bounding_boxes(dil_map);
boxes_right = rd.detect_bounding_boxes(dil_map_right);

[rows cols] = size(boxes);
figure(99);
imshow(df.img_left_bw);

for i = 1:rows
    figure(99); hold on;
    rectangle('Position', boxes(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;


figure(999);
imshow(df.img_right_bw);

[rows cols] = size(boxes_right);

for i = 1:rows
    figure(999); hold on;
    rectangle('Position', boxes_right(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

% Try to match bounding boxes
%c = Corresponder();
%
%bb2 = c.correlate_bounding_boxes(img, boxes, img_right);

% Create Snake
sf = SnakeFactory(Consts.DFLT_NUM_CONTROL_POINTS, 1, .01);
snake_list = sf.init_and_fit_snakes(img, boxes);

snake_list_right = sf.init_and_fit_snakes(img_right, boxes_right);

figure(366);
imshow(df.img_left_bw);

figure(3666);
imshow(df.img_right_bw);

% Collect Snake Data
snake_data_list = cell(length(snake_list), 1);
snake_data_list_right = cell(length(snake_list_right), 1);

for i = 1:length(snake_list)
    figure(366); hold on;
    snake = snake_list{i};
    plot(snake(:, 2), snake(:, 1), 'Marker', 'o', 'Color', 'g');
    
    % Try finding the center of gravity
    [geom iner cpmo] = polygeom(snake(:, 2), snake(:, 1));
    plot(geom(2), geom(3), 'Marker', '.', 'Color', 'blue');
    
    snake_data_list{i} = RegionCorrData(snake, boxes(i, :)); 
end;

for i = 1:length(snake_list_right)
    figure(3666); hold on;
    snake_right = snake_list_right{i};
    plot(snake_right(:, 2), snake_right(:, 1), 'Marker', 'o', 'Color', 'g');
    
    snake_data_list_right{i} = RegionCorrData(snake_right, boxes_right(i, :));
end;

fprintf('LEFT SNAKES COUNT: %d; RIGHT SNAKES COUNT: %d\n', length(snake_data_list), length(snake_data_list_right));

% Try to find the nearest neighbour from one img to the next
close all;
% Try to detect duplicates
matched_diffs = zeros(length(snake_data_list), 1);
match_count = 0;

% Correspondences
correspondences = zeros(4, 1);

for i = 1:length(snake_data_list_right)
    %close all;
    
    %right_snake = snake_list_right{i};
    %figure(111); imshow(df.img_right_bw); hold on;
    %plot(right_snake(:, 2), right_snake(:, 1), 'Marker', 'o', 'Color', 'g');
    
    
    right_data = snake_data_list_right{i};
    
    min_diff_snake = {};
    min_diff = Inf('double');
    matched_index = 0;
    
    % Try not to bother about small snakes
    if right_data.snake_area > Consts.MIN_SNAKE_AREA
        
        for j = 1:length(snake_data_list)
            
            left_data = snake_data_list{j};
            
            p1 = right_data.bb_mid_point;
            p2 = left_data.bb_mid_point;
            
            v_diff_norm = abs(p2(1, 1) - p1(1, 1)) / Consts.MAX_VERTICAL_DISPARITY;
            h_diff_norm = abs(p2(1, 2) - p1(1, 2)) / Consts.MAX_HORIZONTAL_DISPARITY;
            
            if v_diff_norm <= 1 && h_diff_norm <= 1
                fprintf('### H DIFF NORM: %f\n', h_diff_norm);
                fprintf('### V DIFF NORM: %f\n', v_diff_norm);
            end;
            
            % TODO: increase the weight by the power of 2 in case either of
            % the 2 diffs exceeds 1!!!!
            %weight = ternary_conditional((h_diff_norm + v_diff_norm <= 2), norm([v_diff_norm h_diff_norm]), norm([v_diff_norm h_diff_norm]) .^ 2);
            %weight = ternary_conditional((h_diff_norm <= 1 && v_diff_norm <= 1), norm([v_diff_norm h_diff_norm]), norm([v_diff_norm h_diff_norm]) .* 5);
            weight = norm([v_diff_norm h_diff_norm]) * max(h_diff_norm, v_diff_norm);
            
            %weight = 1 ./ norm([abs(p2(1, 1) - p1(1, 1)) abs(p2(1, 2) - p1(1, 2))]);
            
            fprintf('WEIGHT: %f\n', weight);
            
            diff = double(0);
            
            diff = diff + abs(right_data.snake_area - left_data.snake_area);
            diff = diff + (right_data.snake_circumference - left_data.snake_circumference) .^ 2;
            diff = diff + (right_data.snake_area_circum_ratio - left_data.snake_area_circum_ratio) .^ 2;
            diff = diff + (right_data.snake_height - left_data.snake_height) .^ 2;
            diff = diff + (right_data.snake_width - left_data.snake_width) .^ 2;
            
            diff = diff * weight;
            
            fprintf('CURR DIFF: %f\n', diff);
            
            if (diff < min_diff)
                min_diff = diff;
                min_diff_snake = snake_list{j};
                matched_index = j;
            end;
        end;
            
        if min_diff <= Consts.MAX_SNAKE_DIFF_TOLERANCE
            if matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index, 1) > min_diff
                matched_diffs(matched_index, 1) = min_diff;
                
                match_count = match_count + 1;
                
                % TODO: When a better match is found, make sure to kick out
                % the old one, and well, collect matches as well :)
                % Also, see polygeom code above and return the center of
                % gravity of the snakes
                
                fprintf('MIN DIFF FOUND: %f\n', min_diff);
                %figure((10 + i)); imshow(df.img_left_bw); hold on;
                %plot(min_diff_snake(:, 2), min_diff_snake(:, 1), 'Marker', 'o', 'Color', 'g');
                figure; subplot(1, 2, 1), imshow(df.img_left_bw); hold on;
                plot(min_diff_snake(:, 2), min_diff_snake(:, 1), 'Marker', 'o', 'Color', 'g');
            
                right_snake = snake_list_right{i};
                %figure((100 + i)); imshow(df.img_right_bw); hold on;
                subplot(1, 2, 2), imshow(df.img_right_bw); hold on;
                plot(right_snake(:, 2), right_snake(:, 1), 'Marker', 'o', 'Color', 'g');
                
                % Store Correspondences
                [geom iner cpmo] = polygeom(min_diff_snake(:, 2), min_diff_snake(:, 1));
                correspondences(1, match_count) = geom(3);
                correspondences(2, match_count) = geom(2);
                
                [geom iner cpmo] = polygeom(right_snake(:, 2), right_snake(:, 1));
                correspondences(3, match_count) = geom(3);
                correspondences(4, match_count) = geom(2);
            end;
        else
            disp('No suitable match found');
        end;
    else
        disp('Snake too small');
    end;
    
end;

stereo_display(df.img_left_bw, df.img_right_bw, correspondences);

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