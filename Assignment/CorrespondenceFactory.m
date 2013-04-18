classdef CorrespondenceFactory<handle
    %CORRESPONDENCEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = CorrespondenceFactory(right_img_bw, left_img_bw)
            obj.right_img_bw = right_img_bw;
            obj.left_img_bw = left_img_bw;
        end;
        
        function correspondence_matrix = match_snakes(obj, right_snake_list, right_bb_matrix, left_snake_list, left_bb_matrix)
            
            % Get the snake data
            right_snake_data_list = obj.get_data_list_from_snake_and_bb_matrix(right_snake_list, right_bb_matrix);
            left_snake_data_list = obj.get_data_list_from_snake_and_bb_matrix(left_snake_list, left_bb_matrix);
            
            matched_diffs = zeros(max(length(right_snake_data_list), length(left_snake_data_list)), 1);
            match_count = 0;
            correspondence_matrix = zeros(4, 1);
            
            % Match Stuff!
            for i = 1:length(right_snake_data_list)
                right_snake_data = right_snake_data_list{i};
                
                min_diff_snake = {};
                min_diff = Inf('double');
                matched_index = 0;
                
                % Don't bother about small snakes or snakes with a bad
                % aspect ratio
                if (right_snake_data.snake_area > Consts.MIN_SNAKE_AREA && (min(right_snake_data.snake_height, right_snake_data.snake_width) / max(right_snake_data.snake_height, right_snake_data.snake_width)) > Consts.MIN_SNAKE_ASPECT_RATIO)
                    
                    % Loop the left_snake_list to find a minimum match
                    for j = 1:length(left_snake_data_list)
                        left_snake_data = left_snake_data_list{j};
                        
                        right_mid_point = right_snake_data.bb_mid_point;
                        left_mid_point = left_snake_data.bb_mid_point;
                        
                        % Determine weight
                        v_diff_norm = abs(left_mid_point(1, 1) - right_mid_point(1, 1)) / Consts.MAX_VERTICAL_DISPARITY;
                        h_diff_norm = abs(left_mid_point(1, 2) - right_mid_point(1, 2)) / Consts.MAX_HORIZONTAL_DISPARITY;
                    
                        weight = norm([v_diff_norm h_diff_norm]) * max(h_diff_norm, v_diff_norm);
                        
                        % Calculate the difference between the 2 snakes
                        diff = double(0);
                        
                        diff = diff + abs(right_snake_data.snake_area           - left_snake_data.snake_area); 
                        diff = diff + (right_snake_data.snake_circumference     - left_snake_data.snake_circumference) .^ 2;
                        diff = diff + (right_snake_data.snake_area_circum_ratio - left_snake_data.snake_area_circum_ratio) .^ 2;
                        diff = diff + (right_snake_data.snake_height            - left_snake_data.snake_height) .^ 2;
                        diff = diff + (right_snake_data.snake_width             - left_snake_data.snake_width) .^ 2;
            
                        diff = diff * weight;
                        
                        if (diff < min_diff)
                            min_diff = diff;
                            min_diff_snake = left_snake_list{j};
                            matched_index = j;
                        end;
                    end;
                    
                    % Check that the min_diff doesn't exceed threshold.
                    % Just to make sure that we are dealing with genuine
                    % matches only
                    if (min_diff <= Consts.MAX_SNAKE_DIFF_TOLERANCE)
                        
                        % Check if its either the first match for the
                        % feature or a better match than an already matched
                        % feature (in which case replace it!)
                        if matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index, 1) > min_diff
                            
                            matched_diffs(matched_index, 1) = min_diff;
                            match_count = match_count + 1;
                            
                            % Store data in correspondences matrix
                            right_snake = right_snake_list{i};
                            
                            % Own comparison plot
                            figure; subplot(1, 2, 1), imshow(obj.left_img_bw); hold on;
                            plot(min_diff_snake(:, 2), min_diff_snake(:, 1), 'Marker', 'o', 'Color', 'g');
                            subplot(1, 2, 2), imshow(obj.right_img_bw); hold on;
                            plot(right_snake(:, 2), right_snake(:, 1), 'Marker', 'o', 'Color', 'g');
                            
                            % Store Correspondences
                            [geom iner cpmo] = polygeom(min_diff_snake(:, 2), min_diff_snake(:, 1));
                            correspondence_matrix(1, match_count) = geom(3);
                            correspondence_matrix(2, match_count) = geom(2);
                
                            [geom iner cpmo] = polygeom(right_snake(:, 2), right_snake(:, 1));
                            correspondence_matrix(3, match_count) = geom(3);
                            correspondence_matrix(4, match_count) = geom(2);
                        end;
                    end;
                end;
            end;
        end;
        
        function correspondence_matrix = match_lines(obj, right_hough_lines, left_hough_lines)
            
            correspondence_matrix = zeros(4, 1);
            
            % Get the line data
            right_hough_lines_data_list = obj.get_data_list_from_hough_lines(right_hough_lines);
            left_hough_lines_data_list = obj.get_data_list_from_hough_lines(left_hough_lines);
            
            match_count = 0;
            matched_diffs = zeros(length(right_hough_lines_data_list), 1);
            
            % Match Stuff!
            for i = 1:length(right_hough_lines_data_list)
                
                min_diff = Inf('double');
                min_diff_line = {};
                matched_index = 0;
                
                right_hough_data = right_hough_lines_data_list{i};
                
                % Ignore too short lines
                if (right_hough_data.length > Consts.MIN_LINE_LENGTH)
                    
                    % Match with left lines
                    for j = 1:length(left_hough_lines_data_list)
                        left_hough_data = left_hough_lines_data_list{j};
                        
                        % Read data points, they are cartesian, so x = matlab cols; y =
                        % matlab rows
                        x1 = left_hough_data.start_point(1, 1);
                        y1 = left_hough_data.start_point(1, 2);
                        x2 = left_hough_data.end_point(1, 1);
                        y2 = left_hough_data.end_point(1, 2);
                        x3 = right_hough_data.start_point(1, 1);
                        y3 = right_hough_data.start_point(1, 2);
                        x4 = right_hough_data.end_point(1, 1);
                        y4 = right_hough_data.end_point(1, 2);
            
                        diff = double(0);
                        
                        % Length weight
                        factor = (min(left_hough_data.length, right_hough_data.length) < max(left_hough_data.length, right_hough_data.length) * Consts.LINE_LENGTH_TOLERANCE);
                        length_weight = max(((left_hough_data.length - right_hough_data.length) .^ 2) * factor, 1);
            
                        % Angular disparity between the 2 detected lines
                        angular_weight = abs(atand((y2 - y1) / (x2 - x1)) - atand((y4 - y3) / (x4 - x3)));
                        
                        % Spatial weights = the angle between the 2 corresponding points
                        start_spatial_weight = abs(acosd(dot(left_hough_data.start_point, right_hough_data.start_point) / (norm(left_hough_data.start_point) * norm(right_hough_data.start_point))));
                        mid_spatial_weight = abs(acosd(dot(left_hough_data.mid_point, right_hough_data.mid_point) / (norm(left_hough_data.mid_point) * norm(right_hough_data.mid_point))));
                        end_spatial_weight = abs(acosd(dot(left_hough_data.end_point, right_hough_data.end_point) / (norm(left_hough_data.end_point) * norm(right_hough_data.end_point))));
                        
                        % Gray Level difference
                        left_avg_gray = obj.get_line_avg_gray_level(obj.left_img_bw, left_hough_data);
                        right_avg_gray = obj.get_line_avg_gray_level(obj.right_img_bw, right_hough_data);
                        
                        diff = diff + ((left_avg_gray - right_avg_gray) .^ 2);
                        
                        % Diff Theta
                        diff = diff + angular_weight * ((cosd(left_hough_data.theta) - cosd(right_hough_data.theta)) .^ 2);
            
                        % Diff length
                        diff = diff + length_weight * (max(left_hough_data.length, right_hough_data.length) / min(left_hough_data.length, right_hough_data.length));
            
                        % Diff Points
                        diff = diff + norm(left_hough_data.start_point - right_hough_data.start_point) * start_spatial_weight;
                        diff = diff + norm(left_hough_data.mid_point - right_hough_data.mid_point) * mid_spatial_weight;
                        diff = diff + norm(left_hough_data.end_point- right_hough_data.end_point) * end_spatial_weight;
                        
                        if (diff < min_diff)
                            min_diff = diff;
                            min_diff_line = left_hough_data;
                            matched_index = j;
                        end;
                    end;
                    
                    % Check if diff does not exceed threshold
                    if (min_diff <= Consts.MAX_LINE_DIFF_TOLERANCE)
                        
                        % Check if its a new or a better match
                        if (matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index) > min_diff)
                            
                            match_count = match_count + 1;
                            matched_diffs(matched_index, 1) = min_diff;
                            
                            figure(match_count); subplot(1, 2, 1), imshow(obj.left_img_bw); hold on;
                            plot([min_diff_line.start_point(1, 1) min_diff_line.end_point(1, 1)], [min_diff_line.start_point(1, 2) min_diff_line.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
                            subplot(1, 2, 2), imshow(obj.right_img_bw); hold on;
                            plot([right_hough_data.start_point(1, 1) right_hough_data.end_point(1, 1)], [right_hough_data.start_point(1, 2) right_hough_data.end_point(1, 2)], 'LineWidth', 1, 'Color', 'g');
                            
                            % Store Correspondences
                            correspondence_matrix(1, match_count) = min_diff_line.mid_point(1, 2);
                            correspondence_matrix(2, match_count) = min_diff_line.mid_point(1, 1);
                            
                            correspondence_matrix(3, match_count) = right_hough_data.mid_point(1, 2);
                            correspondence_matrix(4, match_count) = right_hough_data.mid_point(1, 1);
                        end;
                    end;
                end;
            end;
        end;
    
        function correspondence_matrix = match_corners(obj, right_corner_matrix, left_corner_matrix)
        
            correspondence_matrix = zeros(4, 1);
            
            % Get the Corner Data
            right_corner_data_list = obj.get_data_list_from_corner_bbs(right_corner_matrix, obj.right_img_bw);
            left_corner_data_list = obj.get_data_list_from_corner_bbs(left_corner_matrix, obj.left_img_bw);
            
            match_count = 0;
            matched_diffs = zeros(length(right_corner_data_list), 1);
            
            % Match Stuff!!!
            for i = 1:length(right_corner_data_list)
                
                min_diff = Inf('double');
                min_diff_corner = {};
                matched_index = 0;
                
                right_corner_data = right_corner_data_list{i, 1};
                
                % In case the merged box is too large, ignore it
                if (right_corner_data.bb_width <= 4 * Consts.CORNER_FRAME_SIZE && right_corner_data.bb_height <= 4 * Consts.CORNER_FRAME_SIZE)
                    
                    for j = 1:length(left_corner_data_list)
                        left_corner_data = left_corner_data_list{j, 1};
                        
                        if (left_corner_data.bb_width <= 4 * Consts.CORNER_FRAME_SIZE && left_corner_data.bb_height <= 4 * Consts.CORNER_FRAME_SIZE)
                            
                            diff = double(0);
                            
                            % Calculate Weight (= Normalised Euclidean Distance, sent through a Polynomial)
                            euclidean_distance = norm(left_corner_data.bb_mid_point - right_corner_data.bb_mid_point);
                            norm_euclidean_dist = euclidean_distance / norm([Consts.MAX_VERTICAL_DISPARITY Consts.MAX_HORIZONTAL_DISPARITY]);
                            
                            % Apply Polynomial to weight (2 * pi * ((norm_euclidean_dist - 1) ^ 2))
                            % This function describes a steeply rising
                            % parabola, centered around x = 1, this has the
                            % effect of symmetrically amplyfing too close
                            % matches and too far away matches
                            weight = ceil(2 * pi * ((norm_euclidean_dist - 1) ^ 2));
                            
                            diff = diff + (left_corner_data.mid_point_gray_level - right_corner_data.mid_point_gray_level) ^ 2;
                            diff = diff + (left_corner_data.avg_gray_level_box_corners - right_corner_data.avg_gray_level_box_corners) ^ 2;
                            diff = diff + (left_corner_data.avg_gray_level_box - right_corner_data.avg_gray_level_box) ^ 2;
                            diff = diff + (left_corner_data.max_gray_level - right_corner_data.max_gray_level) ^ 2;
                            diff = diff + (left_corner_data.min_gray_level - right_corner_data.min_gray_level) ^ 2;
                            
                            diff = diff * weight;
                            
                            if (diff < min_diff)
                                min_diff = diff;
                                min_diff_corner = left_corner_data;
                                matched_index = j;
                            end;
                        end;
                        
                        % Check if diff does not exceed threshold
                        if (min_diff <= Consts.MAX_CORNER_DIFF_TOLERANCE)
                            
                            % Check if its a new or a better match
                            if (matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index) > min_diff)
                            
                                match_count = match_count + 1;
                                matched_diffs(matched_index, 1) = min_diff;
                                
                                figure(match_count); subplot(1, 2, 1), imshow(obj.left_img_bw); hold on;
                                plot(min_diff_corner.bb_mid_point(1, 2), min_diff_corner.bb_mid_point(1, 1), '.','Color', 'g');
                                subplot(1, 2, 2), imshow(obj.right_img_bw); hold on;
                                plot(right_corner_data.bb_mid_point(1, 2), right_corner_data.bb_mid_point(1, 1), '.', 'Color', 'g');
                                
                                correspondence_matrix(1, match_count) = min_diff_corner.bb_mid_point(1, 1);
                                correspondence_matrix(2, match_count) = min_diff_corner.bb_mid_point(1, 2);
                                correspondence_matrix(3, match_count) = right_corner_data.bb_mid_point(1, 1);
                                correspondence_matrix(4, match_count) = right_corner_data.bb_mid_point(1, 2);
                                
                            end;
                        end;
                    end;
                end;
            end;
        end;
    
        function correspondence_matrix = match_quadtrees(obj, right_quadtree_data_list, left_quadtree_data_list)
            
            correspondence_matrix = zeros(4, 1);
            
            match_count = 0;
            matched_diffs = zeros(length(right_quadtree_data_list), 1);
            
            for i = 1:length(right_quadtree_data_list)
                
                right_qt_data = right_quadtree_data_list{i, 1};
                size_right_qt = size(right_qt_data.blocks);
                
                for j = 1:length(left_quadtree_data_list)
                    
                    min_diff = Inf('double');
                    min_diff_qt = {};
                    matched_index = 0;
                    
                    left_qt_data = left_quadtree_data_list{j, 1};
                    size_left_qt = size(left_qt_data.blocks);
                    
                    % If the Quadtrees, are not of the same size, ignore them
                    % straight away
                    if (norm(size_left_qt - size_right_qt) == 0 && right_qt_data.bb(1, 3) * right_qt_data.bb(1, 4) > Consts.MIN_QUADTREE_BB_SIZE)
                        
                        % Calculate Weight (= Normalised Euclidean Distance, sent through a Polynomial)
                        euclidean_distance = norm(left_qt_data.bb_mid_point - right_qt_data.bb_mid_point);
                        norm_euclidean_dist = euclidean_distance / norm([Consts.MAX_VERTICAL_DISPARITY Consts.MAX_HORIZONTAL_DISPARITY]);
                            
                        % Apply Polynomial to weight (2 * pi * ((norm_euclidean_dist - 1) ^ 2))
                        % This function describes a steeply rising
                        % parabola, centered around x = 1, this has the
                        % effect of symmetrically amplyfing too close
                        % matches and too far away matches
                        weight = ceil(2 * pi * ((norm_euclidean_dist - 1) ^ 2));
                        
                        diff = right_qt_data.blocks - left_qt_data.blocks;
                        
                        impurity = length(find(diff~=0)) * weight;
                        
                        if (length(impurity) < min_diff)
                            min_diff = impurity;
                            matched_index = j;
                            min_diff_qt = left_qt_data;
                        end;
                    end;
                    if (min_diff <=  Consts.QUADTREE_DIFF_TOLERANCE)
                        if (matched_diffs(matched_index, 1) == 0 || matched_diffs(matched_index) > min_diff)
                            
                            match_count = match_count + 1;
                            matched_diffs(matched_index, 1) = min_diff;
                            
                            figure(match_count); subplot(1, 2, 1), imshow(obj.left_img_bw); hold on;
                            rectangle('Position', min_diff_qt.bb, 'LineWidth', 1, 'EdgeColor', 'r');
                            subplot(1, 2, 2), imshow(obj.right_img_bw); hold on;
                            rectangle('Position', right_qt_data.bb, 'LineWidth', 1, 'EdgeColor', 'r');
                            
                            correspondence_matrix(1, match_count) = min_diff_qt.bb_mid_point(1, 1);
                            correspondence_matrix(2, match_count) = min_diff_qt.bb_mid_point(1, 2);
                            correspondence_matrix(3, match_count) = right_qt_data.bb_mid_point(1, 1);
                            correspondence_matrix(4, match_count) = right_qt_data.bb_mid_point(1, 2);
                        end;
                    end;
                end;
            end;
            
        end;
    end;
    
    properties (SetAccess = private, GetAccess = public)
        left_img_bw;
        right_img_bw;
    end
    
    methods (Access = private)
        
        function corner_data_list = get_data_list_from_corner_bbs(obj, corner_bbs, img)
            corner_data_list = cell(length(corner_bbs), 1);
            
            for i = 1:length(corner_bbs)
                corner_data_list{i, 1} = CornerCorrData(corner_bbs(i, :), img);
            end;
        end;
        
        function line_data_list = get_data_list_from_hough_lines(obj, hough_lines)
            line_data_list = cell(length(hough_lines), 1);
            
            for i = 1:length(hough_lines)
                line_data_list{i, 1} = LineCorrData(hough_lines(i));
            end;
        end;
        
        function snake_data_list = get_data_list_from_snake_and_bb_matrix(obj, snake_list, bb_matrix)
            
            snake_data_list = cell(length(snake_list), 1);
            
            for i = 1:length(snake_list)
                snake_data_list{i, 1} = SnakeCorrData(snake_list{i}, bb_matrix(i, :));
            end;
        end;
        
        function line_avg_gray_level = get_line_avg_gray_level(obj, img, hough_data)
            line_patch = img(hough_data.start_point(1, 2):hough_data.end_point(1, 2), hough_data.start_point(1, 1):hough_data.end_point(1, 1));
            
            line_avg_gray_level = mean(line_patch(:));
        end;
    end;
    
end

