close all;

df = DataFactory();

corners = corner(df.img_left_bw);

figure; imshow(df.img_left_bw); hold on;
plot(corners(:, 1), corners(:, 2), '.', 'Color', 'g');

edge_map = edge(df.img_left_bw);
edge_map = bwmorph(edge_map, 'dilate');

figure(45); imshow(edge_map); hold on;
edge_corners = corner(edge_map);
plot(edge_corners(:, 1), edge_corners(:, 2), '+', 'Color', 'g');





img = imfilter(df.img_left_bw, h);
img = imfilter(img, h);

dil_edge = edge(img, 'canny');
figure(12); imshow(dil_edge);
