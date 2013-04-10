close all;

df = DataFactory();

%{
sobel_edges = edge(df.img_left_bw, 'sobel');
figure; set(gcf, 'name', 'Sobel Edges'); imshow(sobel_edges);
dil_sobel = bwmorph(sobel_edges, 'dilate');
figure; set(gcf, 'name', 'Sobel Dilated'); imshow(dil_sobel);

prewitt_edges = edge(df.img_left_bw, 'prewitt');
figure; set(gcf, 'name', 'Prewitt Edges'); imshow(prewitt_edges);
dil_prewitt = bwmorph(prewitt_edges, 'dilate');
figure; set(gcf, 'name', 'Prewitt Dilated'); imshow(dil_prewitt);

roberts_edges = edge(df.img_left_bw, 'roberts');
figure; set(gcf, 'name', 'Roberts Edges'); imshow(roberts_edges);
dil_roberts = bwmorph(roberts_edges, 'dilate');
figure; set(gcf, 'name', 'Roberts Dilated'); imshow(dil_roberts);

laplacian_edges = edge(df.img_left_bw, 'log');
figure; set(gcf, 'name', 'Laplacian Edges'); imshow(laplacian_edges);
dil_laplacian = bwmorph(laplacian_edges, 'dilate');
figure; set(gcf, 'name', 'Laplacian Dilated'); imshow(dil_laplacian);

zero_cross_edges = edge(df.img_left_bw, 'zerocross');
figure; set(gcf, 'name', 'Zero Cross Edges'); imshow(zero_cross_edges);
dil_zero_cross = bwmorph(zero_cross_edges, 'dilate');
figure; set(gcf, 'name', 'Zero Cross Dilated'); imshow(dil_zero_cross);

canny_edges = edge(df.img_left_bw, 'canny');
figure; set(gcf, 'name', 'Canny Edges'); imshow(canny_edges);
dil_canny = bwmorph(canny_edges, 'dilate');
figure; set(gcf, 'name', 'Canny Dilated'); imshow(dil_canny);
%}

%{
edge_map = edge(df.img_left_bw, 'canny');

bothat_img = bwmorph(edge_map, 'bothat');
figure; set(gcf, 'name', 'BotHat'); imshow(bothat_img);

tophat_img = bwmorph(edge_map, 'tophat', 2);
figure; set(gcf, 'name', 'TopHat'); imshow(tophat_img);

branch_img = bwmorph(edge_map, 'branchpoints');
figure; set(gcf, 'name', 'Branchpoints'); imshow(branch_img);

bridge_img = bwmorph(edge_map, 'bridge');
figure; set(gcf, 'name', 'Bridge'); imshow(bridge_img);

clean_img = bwmorph(edge_map, 'clean', 2);
figure; set(gcf, 'name', 'Clean'); imshow(clean_img);

majority_img = bwmorph(edge_map, 'dilate');
majority_img = bwmorph(majority_img, 'majority', 1);
figure; set(gcf, 'name', 'Majority'); imshow(majority_img);
%}

rd = RegionDetector();

edge_map = edge(df.img_left_bw);
edge_map = bwmorph(edge_map, 'dilate');
edge_map = bwmorph(edge_map, 'majority');

boxes = rd.detect_bounding_boxes(edge_map);

[rows cols] = size(boxes);
figure(99);
imshow(df.img_left_bw);

for i = 1:rows
    figure(99); hold on;
    rectangle('Position', boxes(i, :), 'LineWidth', 1, 'EdgeColor', 'r');
end;