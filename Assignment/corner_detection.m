close all;

df = DataFactory();

img_size = size(df.img_left_bw);

h = fspecial('gauss', [11 2]);
img = df.img_left_bw;

for i = 1:200
    img = imfilter(img, h, 'replicate');
end;

corners = corner(img);

% Overlay very bright areas
%[rows cols] = ind2sub(size(img), find(img >= 0.9 * max(img(:))));
%img(rows, cols) = mean(img(:));

figure(12); imshow(img); hold on;
plot(corners(:, 1), corners(:, 2), '.', 'Color', 'g');

corner_bins = {};
bin_count = 1;
num_corners = length(corners);

while num_corners > 1
    
    fprintf('NUM CORNERS: %d\n', num_corners);
    
    x = corners(1, 1);
    y = corners(1, 2);
    
    x_idx_in_range = find(corners(:, 1) <= x + Consts.CORNER_FRAME_SIZE & corners(:, 1) >= x - Consts.CORNER_FRAME_SIZE);
    y_idx_in_range = find(corners(:, 2) <= y + Consts.CORNER_FRAME_SIZE & corners(:, 2) >= y - Consts.CORNER_FRAME_SIZE);
    
    idx_intersect = intersect(x_idx_in_range, y_idx_in_range);
    
    corner_bins{bin_count} = corners(idx_intersect, :);
    bin_count = bin_count + 1;
    
    corners = setdiff(corners, corners(idx_intersect, :), 'rows');
    num_corners = num_corners - length(idx_intersect);
end;

fprintf('BINS: %d\n', length(corner_bins));

corner_frames = cell(length(corner_bins), 1);

for i = 1:length(corner_bins)
    bin = corner_bins{i};
    
    bin_size = size(bin);
    if bin_size(1, 1) <= 1 % THEST
    if (bin_size(1, 1) == 1)
        % Single Corner
        mid_col = bin(1, 1);
        mid_row = bin(1, 2);
        
        frame_size = Consts.CORNER_FRAME_SIZE;
    elseif (bin_size(1, 1) == 2)
        % "Edge" Corner
        mid_col = abs(bin(1, 1) - bin(2, 1)) / 2;
        mid_row = abs(bin(1, 2) - bin(2, 1)) / 2;
        
        frame_size = Consts.CORNER_FRAME_SIZE;
    else
        % Geometric Corner
        [geom iner cpmo] = polygeom(bin(:, 1), bin(:, 2));
        mid_col = geom(2);
        mid_row = geom(3);
        
        frame_size = max(bin(:) - min(bin(:)));
    end;
    
    min_col = max(mid_col - frame_size, 1);
    max_col = min(mid_col + frame_size, img_size(1, 2));
    min_row = max(mid_row - frame_size, 1);
    max_row = min(mid_row + frame_size, img_size(1, 1));
        
    height = max_row - min_row;
    width = max_col - min_col;
        
    corner_frames{i, 1} = [min_col min_row width height];
    figure(12); rectangle('Position', corner_frames{i, 1}, 'LineWidth', 1, 'EdgeColor', 'r');
    
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
    end;
end;

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