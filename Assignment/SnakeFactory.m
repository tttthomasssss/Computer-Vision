classdef SnakeFactory<handle
    %SNAKEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    methods (Access = public)
        function obj = SnakeFactory(preferred_n_control_points, alpha, beta)
            
            %{
            TODO: Alpha Beta
            
            either 
                use average gray level of whole bounding box
            or
                take center of gravity as intrinsic and average the corner
                points as extrinsic
            
            
            can use poly2mask to create a mask from the snake polygon and
            then can do correlation
            %}
            
            if nargin < 1
                preferred_n_control_points = Consts.DFLT_NUM_CONTROL_POINTS;
                alpha = rand;
                beta = rand;
            elseif nargin < 2
                alpha = rand;
                beta = rand;
            end;
            
            obj.n_control_points = preferred_n_control_points;
            obj.snake_alpha = alpha;
            obj.snake_beta = beta;
            
            %{
            % THIS WORKS
            % Init a snake
            [x y] = obj.get_basic_snake_for_feature(feature_bb);
            
            figure(2323);
            imshow(image); hold on;
            plot(y, x, 'Marker', 'o', 'Color', 'g');
            
            snake = obj.fit_snake(image, [x y]);
            
            a = snake(1:end, 1);
            b = snake(1:end, 2);
            
            figure(3232);
            imshow(image); hold on;
            plot(b, a, 'Marker', 'o', 'Color', 'g');
            %}
        end
        
        function initial_snake_list = init_snakes(obj, bb_matrix)
            obj.bb_matrix = bb_matrix;
            
            [bb_rows bb_cols] = size(bb_matrix);
            
            initial_snake_list = cell(bb_rows, 1);
            
            for i = 1:bb_rows
                [xs ys] = obj.get_basic_snake_for_feature(bb_matrix(i, :));
                initial_snake_list{i} = [xs ys];
                disp(initial_snake_list);
            end;
            disp(initial_snake_list);
        end
        
        function snake_list = init_and_fit_snakes(obj, image, bb_matrix)
        
            initial_snake_list = init_snakes(obj, bb_matrix);
            
            snake_list = cell(size(initial_snake_list));
            
            for i = 1:length(initial_snake_list)
                %[alpha beta] = obj.smart_weights(image, bb_matrix(i, :));
                [alpha beta] = obj.entropy_weights(image, bb_matrix(i, :));
                snake_list{i} = obj.fit_snake(image, initial_snake_list{i}, alpha, beta);
            end;
            
        end
    end
    
    properties (GetAccess = public, SetAccess = public)
        n_control_points;   % Number of Control points for the snake
        snake_alpha;        % Alpha value for snake
        snake_beta;         % Beta value for snake
        x_snake;            % Vector containing x coordinates of final snake
        y_snake;            % Vector containing y coordinates of final snake
        bb_matrix;          % Bounding Box Matrix
    end
    
    methods (Access = private)
        
        function snake = fit_snake(obj, image, init_control_points, alpha, beta)
            
            snake = zeros(size(init_control_points));
            
            [img_rows img_cols] = size(image);
            
            disp(size(image));
            
            for i = 1:length(init_control_points)
                x = init_control_points(i, 1);
                xl = init_control_points(max(i - 1, 1), 1);
                xr = init_control_points(min(i + 1, length(snake)), 1);
                
                y = init_control_points(i, 2);
                yl = init_control_points(max(i - 1, 1), 2);
                yr = init_control_points(min(i + 1, length(snake)), 2);
                
                % Fit x-coord of snake
                %x_extl_force = x + obj.snake_alpha * (((xl + xr) / 2) - x);
                %x_intl_force = obj.snake_beta * (image(x, max(y - 1, 1)) - image(x, min(y + 1, img_cols)));
                x_extl_force = x + alpha * (((xl + xr) / 2) - x);
                x_intl_force = beta * abs(image(x, max(y - 1, 1)) - image(x, min(y + 1, img_cols))); 
                
                % Prevent the snake point from going out of bounds
                x_new = min(round(x_extl_force + x_intl_force), img_rows);
                
                count = 1;
                
                while x ~= x_new && count <= Consts.MAX_ITERATIONS;
                    
                    x = x_new;
                    
                    %x_extl_force = x + obj.snake_alpha * (((xl + xr) / 2) - x);
                    %x_intl_force = obj.snake_beta * (image(x, max(y - 1, 1)) - image(x, min(y + 1, img_cols)));
                    x_extl_force = x + alpha * (((xl + xr) / 2) - x);
                    x_intl_force = beta * abs(image(x, max(y - 1, 1)) - image(x, min(y + 1, img_cols)));
                    
                    x_new = min(round(x_extl_force + x_intl_force), img_rows);
                    
                    count = count + 1;
                end;
                
                snake(i, 1) = x_new;
                
                % Fit y-coord of snake
                %y_extl_force = y + obj.snake_alpha * (((yl + yr) / 2) - y);
                %y_intl_force = obj.snake_alpha * (image(max(x - 1, 1), y) - image(min(x + 1, img_rows), y));
                y_extl_force = y + alpha * (((yl + yr) / 2) - y);
                y_intl_force = beta * abs(image(max(x - 1, 1), y) - image(min(x + 1, img_rows), y));
                
                y_new = min(round(y_extl_force + y_intl_force), img_cols);
                
                count = 1;
                
                while y ~= y_new && count <= Consts.MAX_ITERATIONS;
                    
                    y = y_new;
                    
                    %y_extl_force = y + obj.snake_alpha * (((yl + yr) / 2) - y);
                    %y_intl_force = obj.snake_alpha * (image(max(x - 1, 1), y) - image(min(x + 1, img_rows), y));
                    y_extl_force = y + alpha * (((yl + yr) / 2) - y);
                    y_intl_force = beta * abs(image(max(x - 1, 1), y) - image(min(x + 1, img_rows), y));
                    
                    y_new = min(round(y_extl_force + y_intl_force), img_cols);
                    
                    count = count + 1;
                end;
                
                snake(i, 2) = y_new;
                
            end;
            
            snake(length(init_control_points) + 1, 1) = snake(1, 1);
            snake(length(init_control_points) + 1, 2) = snake(1, 2);
            
        end
        
        function [xs ys] = get_basic_snake_for_feature(obj, feature_bb)
            
            min_col = feature_bb(1, 1);
            min_row = feature_bb(1, 2);
            width = feature_bb(1, 3);
            height = feature_bb(1, 4);
            
            [obj.n_control_points spacing] = obj.smart_spacing(width, height);
            
            xs = zeros(obj.n_control_points + 1, 1);
            ys = zeros(obj.n_control_points + 1, 1);
            
            points = 1;
            
            % 4 Corners of Bounding Box
            top_left_row = min_row;
            top_left_col = min_col;
            
            top_right_row = min_row;
            top_right_col = min_col + width;
            
            bottom_right_row = min_row + height;
            bottom_right_col = min_col + width;
            
            bottom_left_row = min_row + height;
            bottom_left_col = min_col;
            
            % Now squeeze some more points inbetween
            xs(points, 1) = top_left_row;
            ys(points, 1) = top_left_col;
            points = points + 1;
            
            curr_col_pos = min_col + spacing;
            curr_row_pos = min_row;
            
            % Top Line
            while curr_col_pos <= min_col + width - (spacing / 2) && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_col_pos = curr_col_pos + spacing;
            end;
            
            % Right Line
            xs(points, 1) = top_right_row;
            ys(points, 1) = top_right_col;
            points = points + 1;
            
            curr_col_pos = min_col + width;
            curr_row_pos = min_row + spacing;
            while curr_row_pos <= min_row + height - (spacing / 2) && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_row_pos = curr_row_pos + spacing;
            end;
            
            % Bottom Line
            xs(points, 1) = bottom_right_row;
            ys(points, 1) = bottom_right_col;
            points = points + 1;
            
            curr_col_pos = min_col + width - spacing;
            curr_row_pos = min_row + height;
            while curr_col_pos > min_col + (spacing / 2) && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_col_pos = curr_col_pos - spacing;
            end;
            
            % Left Line
            xs(points, 1) = bottom_left_row;
            ys(points, 1) = bottom_left_col;
            points = points + 1;
            
            curr_col_pos = min_col;
            curr_row_pos = min_row + height - spacing;
            while curr_row_pos > min_row + (spacing / 2)&& points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_row_pos = curr_row_pos - spacing;
            end;
            
            % Quickhack 1: In case not all points fit, the last point
            % will be at the origin. If that is the case, just replace the
            % 0/0 coords with the coords of the first point in the snake
            % In any other case add a last point to the snake which
            % essentially is the first point
            if xs(length(xs), 1) == 0 && ys(length(ys), 1) == 0
                xs(length(xs), 1) = xs(1, 1);
                ys(length(ys), 1) = ys(1, 1);
            else
                xs(length(xs) + 1, 1) = xs(1, 1);
                ys(length(ys) + 1, 1) = ys(1, 1);
            end;
            
            % Quickhack 2: Get rid of unused control points inbetween
            x_unused = ind2sub(size(xs), find(xs == 0));
            y_unused = ind2sub(size(ys), find(ys == 0));
            
            if ~isempty(x_unused) && ~isempty(y_unused) && isequal(x_unused, y_unused)
                x_min = min(x_unused(:));
                x_max = max(x_unused(:));
                y_min = min(y_unused(:));
                y_max = max(y_unused(:));
                
                xs = [xs(1:x_min - 1, 1); xs(x_max + 1:end)];
                ys = [ys(1:y_min - 1, 1); ys(y_max + 1:end)];
            end;
                
        end;
        
        function [control_points spacing] = smart_spacing(obj, width, height)
            
            control_points = obj.n_control_points;
            
            % Circumference of the BB
            u = 2 .* (width + height);
            
            spacing = 0;
            
            % ...lamb's blood painted door, I shall pass...
            creeping_death = 1;
            
            % If spacing not within range, halve or double the amount of
            % control points until it fits
            while spacing < Consts.MIN_SNAKE_SPACING || spacing > Consts.MAX_SNAKE_SPACING
                
                control_points = ternary_conditional(spacing < Consts.MIN_SNAKE_SPACING, round(control_points / creeping_death), control_points * creeping_death);
                
                % The cryptic way to say it should never exceed the next multiple of 2...
                creeping_death = creeping_death + mod(creeping_death, 2);
                
                spacing = round(u / control_points);
                
            end;
            
        end;
        
        function [alpha beta] = smart_weights(obj, curr_img, curr_bounding_box)
            
            min_col = curr_bounding_box(1, 1);
            min_row = curr_bounding_box(1, 2);
            max_col = min_col + curr_bounding_box(1, 3);
            max_row = min_row + curr_bounding_box(1, 4);
            
            bb_img = curr_img(min_row:max_row, min_col:max_col);
            
            % Get Gray Level of central point in image
            center_col = min_col + round(curr_bounding_box(1, 3) ./ 2);
            center_row = min_row + round(curr_bounding_box(1, 4) ./ 2);
            
            center_gray_level = curr_img(center_row, center_col);
            
            % Get Gray Level of cornerpoints
            corner_gray_levels = zeros(1, 4);
            corner_gray_levels(1, 1) = bb_img(1, 1);
            corner_gray_levels(1, 2) = bb_img(1, end);
            corner_gray_levels(1, 3) = bb_img(end, 1);
            corner_gray_levels(1, 4) = bb_img(end, end);
            
            beta =  1 ./ abs(mean(corner_gray_levels) - center_gray_level);
            alpha = 1 ./ beta;
        end;
        
        function [alpha beta] = entropy_weights(obj, curr_img, curr_bounding_box)
            min_col = curr_bounding_box(1, 1);
            min_row = curr_bounding_box(1, 2);
            max_col = min_col + curr_bounding_box(1, 3);
            max_row = min_row + curr_bounding_box(1, 4);
            
            bb_img = curr_img(min_row:max_row, min_col:max_col);
            
            e = entropy(bb_img);
            
            % In case entropy should be zero, fallback to gray scale based
            % weights
            if (e <= 0)
                [alpha beta] = obj.smart_weights(curr_img, curr_bounding_box);
            else
                beta = e;
                alpha = 1 / beta;
            end;
        end;
    end
    
end

