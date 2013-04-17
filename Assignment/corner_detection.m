close all;

df = DataFactory();

img_size = size(df.img_left_bw);
img_size_right = size(df.img_right_bw);

h = fspecial('gauss', [11 2]);
img = df.img_left_bw;
img_right = df.img_right_bw;

for i = 1:200
    img = imfilter(img, h, 'replicate');
    img_right = imfilter(img_right, h, 'replicate');
end;

corners = corner(img);
corners_right = corner(img_right);

% Overlay very bright areas
%[rows cols] = ind2sub(size(img), find(img >= 0.9 * max(img(:))));
%img(rows, cols) = mean(img(:));

figure(12); imshow(img); hold on;
plot(corners(:, 1), corners(:, 2), '.', 'Color', 'g');

figure(13); imshow(img_right); hold on;
plot(corners_right(:, 1), corners_right(:, 2), '.', 'Color', 'g');

%{
corner_bins = cell(1, 1);
bin_count = 1;
num_corners = length(corners);

while num_corners > 1
    
    fprintf('NUM CORNERS: %d\n', num_corners);
    
    x = corners(1, 1);
    y = corners(1, 2);
    
    x_idx_in_range = find(corners(:, 1) <= x + Consts.CORNER_FRAME_SIZE & corners(:, 1) >= x - Consts.CORNER_FRAME_SIZE);
    y_idx_in_range = find(corners(:, 2) <= y + Consts.CORNER_FRAME_SIZE & corners(:, 2) >= y - Consts.CORNER_FRAME_SIZE);
    
    idx_intersect = intersect(x_idx_in_range, y_idx_in_range);
    
    corner_bins{bin_count, 1} = corners(idx_intersect, :);
    bin_count = bin_count + 1;
    
    corners = setdiff(corners, corners(idx_intersect, :), 'rows');
    num_corners = num_corners - length(idx_intersect);
end;
%}

rd = RegionDetector();

corner_bins = rd.cluster_corners(corners);
corner_bins_right = rd.cluster_corners(corners_right);

fprintf('BINS: %d\n', length(corner_bins));
fprintf('BINS RIGHT: %d\n', length(corner_bins_right));

corner_bbs = rd.extract_bounding_box_patches_from_corner_clusters(corner_bins, df.img_left_bw);
corner_bbs_right = rd.extract_bounding_box_patches_from_corner_clusters(corner_bins_right, df.img_right_bw);

corners_left_data_list = cell(length(corner_bbs), 1);
corners_right_data_list = cell(length(corner_bbs_right), 1);

for i = 1:length(corner_bbs)
    corners_left_data_list{i, 1} = CornerCorrData(corner_bbs(i, :), df.img_left_bw);
    figure(12); rectangle('Position', corner_bbs(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

for i = 1:length(corner_bbs_right)
    corners_right_data_list = CornerCorrData(corner_bbs_right(i, :), df.img_right_bw);
    figure(13); rectangle('Position', corner_bbs_right(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

corr_factory = CorrespondenceFactory(df.img_right_bw, df.img_left_bw);

correspondences = corr_factory.match_corners(corner_bbs_right, corner_bbs);

%corner_frames = cell(length(corner_bins), 1);

% for i = 1:length(corner_bins)
%     bin = corner_bins{i, 1};
%     
%     bin_size = size(bin);
%     if (bin_size(1, 1) == 1)
%         % Single Corner
%         mid_col = bin(1, 1);
%         mid_row = bin(1, 2);
%         
%         frame_size = Consts.CORNER_FRAME_SIZE;
%     elseif (bin_size(1, 1) == 2)
%         % "Edge" Corner
%         mid_col = round(min(bin(1, 1), bin(2, 1)) + abs(bin(1, 1) - bin(2, 1)) / 2);
%         mid_row = round(min(bin(1, 2), bin(2, 2)) + abs(bin(1, 2) - bin(2, 2)) / 2);
%         
%         frame_size = Consts.CORNER_FRAME_SIZE;
%     else
%         % Geometric Corner
%         [geom iner cpmo] = polygeom(bin(:, 1), bin(:, 2));
%         mid_col = round(geom(2));
%         mid_row = round(geom(3));
%         
%         frame_size = max(bin(:) - min(bin(:)));
%     end;
%     
%     min_col = max(mid_col - frame_size, 1);
%     max_col = min(mid_col + frame_size, img_size(1, 2));
%     min_row = max(mid_row - frame_size, 1);
%     max_row = min(mid_row + frame_size, img_size(1, 1));
%         
%     height = max_row - min_row;
%     width = max_col - min_col;
%         
%     corner_frames{i, 1} = [min_col min_row width height];
    %figure(12); rectangle('Position', corner_frames{i, 1}, 'LineWidth', 1, 'EdgeColor', 'r');
    
    %{
    mask = img(min_row:max_row, min_col:max_col);
    
    % Apply some self-similarity thresholding
    avg_gray_level = mean(mask(:));
    thresh_img = thresholding(img, 0.98 * avg_gray_level, 1.02 * avg_gray_level);
    img = img + thresh_img;
    
    templ = flipud(mask);
    conv_img = convolve2(img, templ, 'reflect');
    figure(21); imshow(conv_img, []); hold on;
    
    %conv_img = normalise_matrix(conv_img, 1, 0);
    
    %[idy idx] = ind2sub(size(conv_img), find(conv_img >= 0.95 * max(conv_img(:))));
    %plot(idx, idy, '.', 'Color', 'green');
    [rows cols vals] = findpeaks(img);
    bigpeakindex = vals > 0.8 * max(vals);
    bigpeakrows = rows(bigpeakindex);
    bigpeakcols = cols(bigpeakindex);
    plot(bigpeakcols, bigpeakrows, 'g*');
    %}
%end;

%{
figure(45); imshow(edge_map); hold on;
edge_corners = corner(edge_map);
plot(edge_corners(:, 1), edge_corners(:, 2), '.', 'Color', 'g');

h = fspecial('gauss', [5 5]);
img = imfilter(df.img_left_bw, h, 'replicate');
for i = 1:50
    img = imfilter(img, h);
end;
c = corner(img);
figure; set(gcf, 'name', 'gaussed image'); imshow(df.img_left_bw); hold on;
plot(c(:, 1), c(:, 2), '.', 'Color', 'g');
%}