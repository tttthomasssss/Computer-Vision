close all;

df = DataFactory();

%subplot(1, 2, 1), imshow(df.img_left_bw);
%subplot(1, 2, 2), imshow(df.img_right_bw);

% Morph Image
h = fspecial('gauss', [5 5]);
img = imfilter(df.img_left_bw, h, 'replicate');
for i = 1:130
    img = imfilter(img, h, 'replicate');
end;

% Morph Right Image
img_right = imfilter(df.img_right_bw, h);
for i = 1:130
    img_right = imfilter(img_right, h, 'replicate');
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

lf = LineFactory();
lines = lf.retrieve_hough_lines(edge_map);
lines_right = lf.retrieve_hough_lines(edge_map_right);

%{
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
peaks = houghpeaks(H, length(r), 'threshold', max(H(:)) * 0.5);

x = theta(peaks(:, 2));
y = rho(peaks(:, 1));
plot(x, y, 's', 'color', 'black');

peaks_right = houghpeaks(H_right, length(r_r), 'threshold', max(H(:)) * 0.5);
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
%}
%{
% MATCH LINES HERE 
match_count = 0;
matched_diffs = zeros(length(line_data_list), 1);

for i = 1:length(line_data_list_right)

    right_data = line_data_list_right{i};
    
    min_diff = Inf('double');
    min_diff_line = {};
    matched_index = 0;
    
    if (right_data.length >= Consts.MIN_LINE_LENGTH)
        
        match_count = match_count + 1;
        
        if match_count == 10 || match_count == 13% || match_count == 6 || match_count == 10 || match_count == 11 || match_count == 13 || match_count == 18 || match_count == 17 || match_count == 28 || match_count == 30
        %    fprintf('MATCH COUNT: %d\n', match_count)
            disp('stuff');
        end;
        
        % Match with left lines
        for j = 1:length(line_data_list)
            left_data = line_data_list{j};
            
            % Read data points, they are cartesian, so x = matlab cols; y =
            % matlab rows
            x1 = left_data.start_point(1, 1);
            y1 = left_data.start_point(1, 2);
            x2 = left_data.end_point(1, 1);
            y2 = left_data.end_point(1, 2);
            x3 = right_data.start_point(1, 1);
            y3 = right_data.start_point(1, 2);
            x4 = right_data.end_point(1, 1);
            y4 = right_data.end_point(1, 2);
            
            diff = double(0);
            
            % Length weight
            factor = (min(left_data.length, right_data.length) < max(left_data.length, right_data.length) * Consts.LINE_LENGTH_TOLERANCE);
            length_weight = max(((left_data.length - right_data.length) .^ 2) * factor, 1);
            
            % Angular disparity between the 2 detected lines
            angular_weight = abs(atand((y2 - y1) / (x2 - x1)) - atand((y4 - y3) / (x4 - x3)));
            
            % Rho weight, given Theta, estimate a rho value for the
            % matching object in image 2 and related the actual rho value
            % with the estimated one
            %opposite_left = left_data.rho * sind(left_data.theta) + Consts.MAX_HORIZONTAL_DISPARITY;
            %adjacent_left = left_data.rho * cosd(left_data.theta) + Consts.MAX_VERTICAL_DISPARITY;
            
            %estimated_rho_right = norm([opposite_left adjacent_left]);
            
            %rho_weight = max(estimated_rho_right, right_data.rho) / min(estimated_rho_right / right_data.rho) * angular_weight;
            %rho_weight = mean([norm(left_data.start_point - right_data.start_point) norm(left_data.mid_point - right_data.mid_point) norm(left_data.end_point- right_data.end_point)]);
            
            % Gray Level difference
            left_line_patch = df.img_left_bw(left_data.start_point(1, 2):left_data.end_point(1, 2), left_data.start_point(1, 1):left_data.end_point(1, 1));
            right_line_patch = df.img_right_bw(right_data.start_point(1, 2):right_data.end_point(1, 2), right_data.start_point(1, 1):right_data.end_point(1, 1));
            
            left_avg_gray = mean(left_line_patch(:));
            right_avg_gray = mean(right_line_patch(:));
            
            diff = diff + ((left_avg_gray - right_avg_gray) .^ 2);
            
            % Spatial weights = the angle between the 2 corresponding points
            start_spatial_weight = abs(acosd(dot(left_data.start_point, right_data.start_point) / (norm(left_data.start_point) * norm(right_data.start_point))));
            mid_spatial_weight = abs(acosd(dot(left_data.mid_point, right_data.mid_point) / (norm(left_data.mid_point) * norm(right_data.mid_point))));
            end_spatial_weight = abs(acosd(dot(left_data.end_point, right_data.end_point) / (norm(left_data.end_point) * norm(right_data.end_point))));
            
            % Diff Theta
            diff = diff + angular_weight * ((cosd(left_data.theta) - cosd(right_data.theta)) .^ 2);
            
            % Diff length
            diff = diff + length_weight * (max(left_data.length, right_data.length) / min(left_data.length, right_data.length));
            
            % Diff Points
            diff = diff + norm(left_data.start_point - right_data.start_point) * start_spatial_weight;
            diff = diff + norm(left_data.mid_point - right_data.mid_point) * mid_spatial_weight;
            diff = diff + norm(left_data.end_point- right_data.end_point) * end_spatial_weight;
            %diff = diff + ((x1 + Consts.MAX_VERTICAL_DISPARITY - x3) .^ 2) * spatial_weight;
            %diff = diff + ((y1 + Consts.MAX_HORIZONTAL_DISPARITY - y3) .^ 2) * spatial_weight;
            %diff = diff + ((x2 + Consts.MAX_VERTICAL_DISPARITY - x4) .^ 2) * spatial_weight;
            %diff = diff + ((y2 + Consts.MAX_HORIZONTAL_DISPARITY - y4) .^ 2) * spatial_weight;
            
            % Diff Rho
            %diff = diff + ((left_data.rho - (right_data.rho + rho_weight)) .^ 2) * angular_weight;
            
            
            %{
            p1 = left_data.mid_point;
            p2 = right_data.mid_point;
            
            h_diff_norm = (abs(p2(1, 1) - p1(1, 1)) + Consts.MAX_HORIZONTAL_DISPARITY) / Consts.MAX_HORIZONTAL_DISPARITY;
            v_diff_norm = (abs(p2(1, 2) - p1(1, 2)) + Consts.MAX_VERTICAL_DISPARITY) / Consts.MAX_VERTICAL_DISPARITY;
            
            weight = norm([h_diff_norm v_diff_norm]) * max(h_diff_norm, v_diff_norm);
            
            % Calc Rho weight as the angle between the 2 lines
            x1 = left_data.start_point(1, 2);
            y1 = left_data.start_point(1, 1);
            x2 = left_data.end_point(1, 2);
            y2 = left_data.end_point(1, 1);
            x3 = right_data.start_point(1, 2);
            y3 = right_data.start_point(1, 1);
            x4 = right_data.end_point(1, 2);
            y4 = right_data.end_point(1, 1);
            rho_weight = abs(atand((y2 - y1) / (x2 - x1)) - atand((y4 - y3) / (x4 - x3)));
            
            % Spatial weights
            % Adjust spatial weights due to general orientation of line (horizontal vs. vertical)
            % eg. weight for horizontal displacement higher if line is
            % vertical
            
            v_weight = abs(cosd(right_data.theta + 90));
            h_weight = abs(sind(right_data.theta + 90));
            
            diff = double(0);
            
            % TODO: MORE ADJUSTING OF WEIGHTS
            diff = diff + weight * ((cosd(left_data.theta) - cosd(right_data.theta)) .^ 2);
            diff = diff + weight * ((left_data.rho - right_data.rho) .^ 2) * rho_weight;
            diff = diff + ((max(left_data.length, right_data.length) * Consts.LINE_LENGTH_TOLERANCE - min(left_data.length, right_data.length)) .^ 2) * weight;
            diff = diff + h_weight * (1 / Consts.MAX_HORIZONTAL_DISPARITY) * (Consts.MAX_HORIZONTAL_DISPARITY + (left_data.start_point(1, 1) - right_data.start_point(1, 1)) .^ 2);% * (abs(left_data.start_point(1, 1) - right_data.start_point(1, 1)) / Consts.MAX_HORIZONTAL_DISPARITY);
            diff = diff + v_weight * (1 / Consts.MAX_VERTICAL_DISPARITY) * (Consts.MAX_VERTICAL_DISPARITY + (left_data.start_point(1, 2) - right_data.start_point(1, 2)) .^ 2);% * (abs(left_data.start_point(1, 2) - right_data.start_point(1, 2)) / Consts.MAX_VERTICAL_DISPARITY);
            diff = diff + h_weight * (1 / Consts.MAX_HORIZONTAL_DISPARITY) * (Consts.MAX_HORIZONTAL_DISPARITY + (left_data.end_point(1, 1) - right_data.end_point(1, 1)) .^ 2);% * (abs(left_data.end_point(1, 1) - right_data.end_point(1, 1)) / Consts.MAX_HORIZONTAL_DISPARITY);
            diff = diff + v_weight * (1 / Consts.MAX_VERTICAL_DISPARITY) * (Consts.MAX_VERTICAL_DISPARITY + (left_data.end_point(1, 2) - right_data.end_point(1, 2)) .^ 2);% * (abs(left_data.end_point(1, 2) - right_data.end_point(1, 2)) / Consts.MAX_VERTICAL_DISPARITY);
            %diff = diff + (1 / Consts.MAX_HORIZONTAL_DISPARITY) * ((left_data.mid_point(1, 1) - right_data.mid_point(1, 1)) .^ 2);
            %diff = diff + (1 / Consts.MAX_VERTICAL_DISPARITY) * ((left_data.mid_point(1, 2) - right_data.mid_point(1, 2)) .^ 2);
            
            %diff = diff * weight;
            %}
            
            
            
            
            
            
            
            
            
            
            if (diff < min_diff)
                min_diff = diff;
                matched_index = j;
                min_diff_line = left_data;
            end;
        end;
        
        if (min_diff <= Consts.MAX_LINE_DIFF_TOLERANCE)
            if (matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index) > min_diff)
                matched_diffs(matched_index, 1) = min_diff;
                fprintf('MATCH COUNT: %d; MIN DIFF SCORE: %f\n', match_count, min_diff);
                
                figure(match_count); subplot(1, 2, 1), imshow(df.img_left_bw); hold on;
                plot([min_diff_line.start_point(1, 1) min_diff_line.end_point(1, 1)], [min_diff_line.start_point(1, 2) min_diff_line.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
                
                subplot(1, 2, 2), imshow(df.img_right_bw); hold on;
                plot([right_data.start_point(1, 1) right_data.end_point(1, 1)], [right_data.start_point(1, 2) right_data.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
            end;
        end;
    end;
end;
%}

close all;

corr_factory = CorrespondenceFactory(df.img_right_bw, df.img_left_bw);

correspondences = corr_factory.match_lines(lines_right, lines);

stereo_display(df.img_left_bw, df.img_right_bw, correspondences);

% Recreate Scene from Houghlines
figure; imshow(lf.recreate_scene_from_houghlines(lines, edge_map));
figure; imshow(lf.recreate_scene_from_houghlines(lines_right, edge_map));

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