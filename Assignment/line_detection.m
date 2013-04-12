close all;

df = DataFactory();

%subplot(1, 2, 1), imshow(df.img_left_bw);
%subplot(1, 2, 2), imshow(df.img_right_bw);

% Morph Image
h = fspecial('gauss', [5 5]);
img = imfilter(df.img_left_bw, h);
for i = 1:20
    img = imfilter(img, h);
end;

% Morph Right Image
img_right = imfilter(df.img_right_bw, h);
for i = 1:20
    img_right = imfilter(img_right, h);
end;

% Show Images
figure(2323); imshow(img);
figure(3232); imshow(img_right);

% Create Edge Maps
edge_map = edge(img, 'canny');

edge_map = bwmorph(edge_map, 'dilate');
figure(1111); imshow(edge_map);

edge_map_right = edge(img_right, 'canny');

edge_map_right = bwmorph(edge_map_right, 'dilate');
figure(5454); imshow(edge_map_right);

% Do the Hough Transform
[H, theta, rho] = hough(edge_map, 'RhoResolution', 2);

figure(2222), imshow(imadjust(mat2gray(H)), [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);

[r c v] = find(H > max(H(:)) * 0.3);


[H_right, theta_right, rho_right] = hough(edge_map_right, 'RhoResolution', 2);

figure(777), imshow(imadjust(mat2gray(H_right)), [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);

[r_r c_r v_r] = find(H > max(H(:)) * 0.3);

% Find Houghpeaks
peaks = houghpeaks(H, length(r), 'threshold', max(H(:)) * 0.3);

x = theta(peaks(:, 2));
y = rho(peaks(:, 1));
plot(x, y, 's', 'color', 'black');

peaks_right = houghpeaks(H_right, length(r_r), 'threshold', max(H(:)) * 0.3);
x_right = theta_right(peaks_right(:, 2));
y_right = rho_right(peaks_right(:, 1));
plot(x_right, y_right, 's', 'color', 'black');

% Fit lines
lines = houghlines(edge_map, theta, rho, peaks);

figure(9090), imshow(df.img_left_bw), hold on;
max_len = 0;

line_data_list = cell(1, length(lines));

for k = 1:length(lines)
    
    line_data_list{k} = LineCorrData(lines(k));
    
    % Check if line is of min length
    if norm(lines(k).point1 - lines(k).point2) > 150
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


lines_right = houghlines(edge_map_right, theta_right, rho_right, peaks_right);
figure(8080), imshow(df.img_right_bw), hold on;
max_len_right = 0;

line_data_list_right = cell(length(lines_right));

for k = 1:length(lines_right)
    
    line_data_list_right{k} = LineCorrData(lines_right(k));
    
    if (norm(lines_right(k).point1 - lines_right(k).point2) > 150)
        xy_right = [lines_right(k).point1; lines_right(k).point2];
        plot(xy_right(:, 1), xy_right(:, 2), 'LineWidth', 1, 'Color', 'green');
        
        plot(xy_right(1, 1), xy_right(1, 2), 'x', 'LineWidth', 1, 'Color', 'yellow');
        plot(xy_right(2, 1), xy_right(2, 2), 'x', 'LineWidth', 1, 'Color', 'red');
        
    end;
end;


% MATCH LINES HERE 
match_count = 0;

for i = 1:length(line_data_list_right)

    right_data = line_data_list_right{i};
    
    min_diff = Inf('double');
    min_diff_line = {};
    matched_index = 0;
    
    if (right_data.length >= Consts.MIN_LINE_LENGTH)
        
        match_count = match_count + 1;
        
        if match_count == 19 || match_count == 29
            disp('stuff');
        end;
        
        % Match with left lines
        for j = 1:length(line_data_list)
            left_data = line_data_list{j};
            
            p1 = left_data.mid_point;
            p2 = right_data.mid_point;
            
            h_diff_norm = abs(p2(1, 1) - p1(1, 1)) / Consts.MAX_HORIZONTAL_DISPARITY;
            v_diff_norm = abs(p2(1, 2) - p1(1, 2)) / Consts.MAX_VERTICAL_DISPARITY;
            
            weight = norm([h_diff_norm v_diff_norm]) * max(h_diff_norm, v_diff_norm);
            
            diff = double(0);
            
            diff = diff + weight * ((cosd(left_data.theta) - cosd(right_data.theta)) .^ 2);
            diff = diff + weight * ((left_data.rho - right_data.rho) .^ 2);
            diff = diff + (2 * (max(left_data.length, right_data.length) * 0.65 > min(left_data.length, right_data.length))) * ((left_data.length - right_data.length) .^ 2);
            diff = diff + (1 / Consts.MAX_HORIZONTAL_DISPARITY) * ((left_data.start_point(1, 1) - right_data.start_point(1, 1)) .^ 2);% * (abs(left_data.start_point(1, 1) - right_data.start_point(1, 1)) / Consts.MAX_HORIZONTAL_DISPARITY);
            diff = diff + (1 / Consts.MAX_VERTICAL_DISPARITY) * ((left_data.start_point(1, 2) - right_data.start_point(1, 2)) .^ 2);% * (abs(left_data.start_point(1, 2) - right_data.start_point(1, 2)) / Consts.MAX_VERTICAL_DISPARITY);
            diff = diff + (1 / Consts.MAX_HORIZONTAL_DISPARITY) * ((left_data.end_point(1, 1) - right_data.end_point(1, 1)) .^ 2);% * (abs(left_data.end_point(1, 1) - right_data.end_point(1, 1)) / Consts.MAX_HORIZONTAL_DISPARITY);
            diff = diff + (1 / Consts.MAX_VERTICAL_DISPARITY) * ((left_data.end_point(1, 2) - right_data.end_point(1, 2)) .^ 2);% * (abs(left_data.end_point(1, 2) - right_data.end_point(1, 2)) / Consts.MAX_VERTICAL_DISPARITY);
            %diff = diff + (1 / Consts.MAX_HORIZONTAL_DISPARITY) * ((left_data.mid_point(1, 1) - right_data.mid_point(1, 1)) .^ 2);
            %diff = diff + (1 / Consts.MAX_VERTICAL_DISPARITY) * ((left_data.mid_point(1, 2) - right_data.mid_point(1, 2)) .^ 2);
            
            %diff = diff * weight;
            
            if (diff < min_diff)
                min_diff = diff;
                matched_index = j;
                min_diff_line = left_data;
            end;
        end;
        
        fprintf('MIN DIFF SCORE: %f\n', min_diff);
        
        figure; subplot(1, 2, 1), imshow(df.img_left_bw); hold on;
        plot([min_diff_line.start_point(1, 1) min_diff_line.end_point(1, 1)], [min_diff_line.start_point(1, 2) min_diff_line.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
        
        subplot(1, 2, 2), imshow(df.img_right_bw); hold on;
        plot([right_data.start_point(1, 1) right_data.end_point(1, 1)], [right_data.start_point(1, 2) right_data.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
    end;
end;


%{ 

INTERPOLATION STUFF (WORKS)

% Highlight longest line segment
%plot(xy_long(:, 1), xy_long(:, 2), 'LineWidth', 2, 'Color', 'red');

% Try to interpolate edge map
size_img = size(edge_map);

interpolation = zeros(size_img);

tolerance = 1;

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
    
    h_span = abs(p2(1, 1) - p1(1, 1));
    v_span = abs(p2(1, 2) - p1(1, 2));
    
    % Differentiate horizontal & vertical lines simply by determining
    % whether the horizontal or vertrical difference is larger
    if (h_span > v_span)
        
        v_step = v_span ./ h_span;
        
        if (p1(1, 1) < p2(1, 1))
            x = p1(1, 1);
            actual_y = p1(1, 2);
            y_gradient = ternary_conditional(p1(1, 2) <= p2(1, 2), 1, -1);
        else
            x = p2(1, 1);
            actual_y = p2(1, 2);
            y_gradient = ternary_conditional(p2(1, 2) <= p1(1, 2), 1, -1);
        end;
        
        y = actual_y;
        
        % Redraw Hough line
        while x < max(p1(1, 1), p2(1, 1))
            
            % Apply a 2 Pixel tolerance
            found_pixel = 0;
            i = max(x - tolerance, 1);
            while i <= min(x + tolerance, size_img(1, 2)) && found_pixel == 0
                j = max(y - tolerance, 1);
                while j <= min(y + tolerance, size_img(1, 1)) && found_pixel == 0
                    found_pixel = interpolation(j, i) > 0;
                    j = j + 1;
                end;
                i = i + 1;
            end;
            
            if (found_pixel ~= 0)
                interpolation(y, x) = interpolation(y, x) + 1;
            end;
            
            % Without tolerance
            %if (edge_map(y, x) > 0)
            %    interpolation(y, x) = interpolation(y, x) + 1;
            %end;
            
            x = x + 1;
            actual_y = actual_y + (v_step .* y_gradient);
            y = round(actual_y);
        end;
    else
        
        h_step = h_span ./ v_span;
        
        if (p1(1, 2) < p2(1, 2))
            y = p1(1, 2);
            actual_x = p1(1, 1);
            x_gradient = ternary_conditional(p1(1, 1) < p2(1, 1), 1, -1);
        else
            y = p2(1, 2);
            actual_x = p2(1, 1);
            x_gradient = ternary_conditional(p2(1, 1) < p1(1, 1), 1, -1);
        end;
        
        x = actual_x;
        
        % Redraw Hough Line
        while y < max(p1(1, 2), p2(1, 2))
            
            % Apply a 2 Pixel tolerance
            found_pixel = 0;
            i = max(x - tolerance, 1);
            while i <= min(x + tolerance, size_img(1, 2)) && found_pixel == 0
                j = max(y - tolerance, 1);
                while j <= min(y + tolerance, size_img(1, 1)) && found_pixel == 0
                    found_pixel = interpolation(j, i) > 0;
                    j = j + 1;
                end;
                i = i + 1;
            end;
            
            if (found_pixel ~= 0)
                interpolation(y, x) = interpolation(y, x) + 1;
            end;
            
            % Without tolerance
            %if (edge_map(y, x) > 0)
            %    interpolation(y, x) = interpolation(y, x) + 1;
            %end;
            
            y = y + 1;
            actual_x = actual_x + (h_step .* x_gradient);
            x = round(actual_x);
        end;
    end;
end;

figure; set(gcf, 'name', 'Interpolation'); imshow(interpolation);
%}
%dil_interpolation = bwmorph(interpolation, 'dilate', 5);
%figure; set(gcf, 'name', 'Dilated Interpolation'); imshow(interpolation);