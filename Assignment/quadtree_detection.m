clear;
close all;

df = DataFactory();

h = fspecial('gauss', [5 5]);

%img = df.dilate_grayscale_img(df.img_left_bw, 1, 'diamond', 3);
img = imfilter(df.img_left_bw, h);
img = imfilter(img, h);

img_right = imfilter(df.img_right_bw, h);
img_right = imfilter(img_right, h);

% Luke, the DARK side is stronger! (.15 was the best so far, w/ or w/o erosion)
dil_map = img < 0.15;
dil_map_right = img_right < 0.15;

rd = RegionDetector();

boxes = rd.detect_bounding_boxes(dil_map);
boxes_right = rd.detect_bounding_boxes(dil_map_right);

% Make sure boxes are sized as a power of 2
for i = 1:length(boxes)
    boxes(i, 3) = get_next_power_of_2(boxes(i, 3));
    boxes(i, 4) = get_next_power_of_2(boxes(i, 4));
end;

figure; imshow(df.img_left_bw); hold on;
for i = 1:length(boxes)
    rectangle('Position', boxes(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;

for i = 1:length(boxes_right)
    boxes_right(i, 3) = get_next_power_of_2(boxes(i, 3));
    boxes_right(i, 4) = get_next_power_of_2(boxes(i, 4));
end;

figure; imshow(df.img_right_bw); hold on;
for i = 1:length(boxes_right)
    rectangle('Position', boxes_right(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;
