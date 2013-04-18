clear;
close all;

df = DataFactory();

h = fspecial('gauss', [5 5]);

%img = df.dilate_grayscale_img(df.img_left_bw, 1, 'diamond', 3);
img = imfilter(df.img_left_bw, h);
img = imfilter(img, h);

size_left = size(img);

img_right = imfilter(df.img_right_bw, h);
img_right = imfilter(img_right, h);

size_right = size(img_right);

% Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
dil_map = img < 0.15;
dil_map_right = img_right < 0.15;

rd = RegionDetector();

boxes = rd.detect_bounding_boxes(dil_map);
boxes_right = rd.detect_bounding_boxes(dil_map_right);

qf = QuadtreeFactory();
trees_left = qf.init_quadtrees(boxes, df.img_left_bw);
trees_right = qf.init_quadtrees(boxes_right, df.img_right_bw);

corr_factory = CorrespondenceFactory(df.img_right_bw, df.img_left_bw);
correspondences = corr_factory.match_quadtrees(trees_right, trees_left);

stereo_display(df.img_left_bw, df.img_right_bw, correspondences);

%for i = 1:length(trees_left)
%    figure; imshow(trees_left{i, 1}.blocks, []);
%end;


%{
% Make sure boxes are sized as a power of 2
for i = 1:length(boxes)
    temp = get_next_power_of_2(boxes(i, 3));
    boxes(i, 3) = ternary_conditional(boxes(i, 1) + temp > size_left(1, 2), temp / 2, temp);
    temp  = get_next_power_of_2(boxes(i, 4));
    boxes(i, 4) = ternary_conditional(boxes(i, 2) + temp > size_left(1, 1), temp / 2, temp);
end;

figure; imshow(df.img_left_bw); hold on;
for i = 1:length(boxes)
    rectangle('Position', boxes(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

for i = 1:length(boxes_right)
    temp = get_next_power_of_2(boxes_right(i, 3));
    boxes_right(i, 3) = ternary_conditional(boxes_right(i, 1) + temp > size_right(1, 2), temp / 2, temp);
    temp = get_next_power_of_2(boxes_right(i, 4));
    boxes_right(i, 4) = ternary_conditional(boxes_right(i, 2) + temp > size_right(1, 1), temp / 2, temp);
end;

figure; imshow(df.img_right_bw); hold on;
for i = 1:length(boxes_right)
    rectangle('Position', boxes_right(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

trees_left = cell(length(boxes), 1);
trees_right = cell(length(boxes_right), 1);

for i = 1:length(boxes)
    disp(boxes(i, :));
    slice = df.img_left_bw(boxes(i, 2):boxes(i, 2) + boxes(i, 4) - 1, boxes(i, 1):boxes(i, 1) + boxes(i, 3) - 1);
    qt = qtdecomp(slice, 0.27);
    
    blocks = repmat(uint8(0), size(qt));

    for dim = [512 256 128 64 32 16 8 4 2 1];
        numblocks = length(find(qt==dim));
    
        if (numblocks > 0)
            values = repmat(uint8(1), [dim dim numblocks]);
            values(2:dim, 2:dim, :) = 0;
            blocks = qtsetblk(blocks, qt, dim, values);
        end;
    end;

    blocks(end, 1:end) = 1;
    blocks(1:end, end) = 1;

    trees_left{i, 1} = blocks;
    figure; imshow(blocks, []);
end;

for i = 1:length(boxes_right)
    slice = df.img_right_bw(boxes_right(i, 2):boxes_right(i, 2) + boxes_right(i, 4) - 1, boxes(i, 1):boxes(i, 1) + boxes(i, 3) - 1);
    trees_right{i, 1} = qtdecomp(slice, 0.27);
end;
%}