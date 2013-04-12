close all;

df = DataFactory();

corners = corner(df.img_left_bw);

figure; imshow(df.img_left_bw); hold on;
plot(corners(:, 1), corners(:, 2), '.', 'Color', 'g');

edge_map = edge(df.img_left_bw, 'canny');
edge_map = bwmorph(edge_map, 'dilate');

figure(45); imshow(edge_map); hold on;
edge_corners = corner(edge_map);
plot(edge_corners(:, 1), edge_corners(:, 2), '.', 'Color', 'g');

h = fspecial('gauss', [5 5]);
img = imfilter(df.img_left_bw, h);
for i = 1:20
    img = imfilter(img, h);
end;
c = corner(img);
figure; set(gcf, 'name', 'gaussed image'); imshow(df.img_left_bw); hold on;
plot(c(:, 1), c(:, 2), '.', 'Color', 'g');