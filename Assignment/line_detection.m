close all;

df = DataFactory();

%subplot(1, 2, 1), imshow(df.img_left_bw);
%subplot(1, 2, 2), imshow(df.img_right_bw);

h = fspecial('gauss', [5 5]);
img = imfilter(df.img_left_bw, h);
for i = 1:20
    img = imfilter(img, h);
end;

figure(2323); imshow(img);

edge_map = edge(img, 'canny');

edge_map = bwmorph(edge_map, 'dilate');
figure(1111); imshow(edge_map);

[H, theta, rho] = hough(edge_map, 'RhoResolution', 2);

figure(2222), imshow(imadjust(mat2gray(H)), [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);

[r c v] = find(H > max(H(:)) * 0.3);

% Find Houghpeaks
peaks = houghpeaks(H, length(r), 'threshold', max(H(:)) * 0.3);

x = theta(peaks(:, 2));
y = rho(peaks(:, 1));
plot(x, y, 's', 'color', 'black');

% Fit lines
lines = houghlines(edge_map, theta, rho, peaks);

figure, imshow(df.img_left_bw), hold on;
max_len = 0;

for k = 1:length(lines)
    
    % Check if line is of min length
    if norm(lines(k).point1 - lines(k).point2) > 150;
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:, 1), xy(:, 2), 'LineWidth', 1, 'Color', 'green');
    
        
        % Beginnings & Ends of lines
        plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 1, 'Color', 'yellow');
        plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 1, 'Color', 'red');
        
        % Endpoints of longest line
        len = norm(lines(k).point1 - lines(k).point2);
        if (len > max_len)
            max_len = len;
            xy_long = xy;
        end;
    end;
end;

% Highlight longest line segment
%plot(xy_long(:, 1), xy_long(:, 2), 'LineWidth', 2, 'Color', 'red');

% Try to interpolate edge map
size_img = size(edge_map);

interpolation = zeros(size_img);

for k = 1:length(lines)
    
    %close all;
    %figure; imshow(edge_map); hold on;
    %xy = [lines(k).point1; lines(k).point2];
    %plot(xy(:, 1), xy(:, 2), 'LineWidth', 1, 'Color', 'green');
    
    p1 = lines(k).point1;
    p2 = lines(k).point2;
    
    disp(p1);
    disp(p2);
    
    interpolation(p1(1, 2), p1(1, 1)) = interpolation(p1(1, 2), p1(1, 1)) + 1;
    interpolation(p2(1, 2), p2(1, 1)) = interpolation(p2(1, 2), p2(1, 1)) + 1;
    
    % TODO: Try to redraw the line in the interpolation image
    % The code below still fails a bit
    
    %{
    h_len = abs(p2(1, 1) - p1(1, 1));
    v_len = abs(p2(1, 2) - p1(1, 2));
    
    v_step = v_len ./ h_len;
    
    x = p1(1, 1);
    y = p1(1, 2);
    
    actual_y = double(y);
    
    while x <= h_len
        
        found_pixel = 0;
        
        for i = max(x - 2, 1):min(x + 2, size_img(1, 2))
            for j = max(y - 2, 1):min(y + 2, size_img(1, 1))
                if (i ~= x && j ~= y)
                    found_pixel = 1;
                end;
            end;
        end;
        
        if (found_pixel == 1)
            interpolation(y, x) = interpolation(y, x) + 1;
        end;
        
        x = x + 1;
        actual_y = actual_y + v_step;
        y = round(actual_y);
        
    end;
    %}
end;

figure; set(gcf, 'name', 'Interpolation'); imshow(interpolation);