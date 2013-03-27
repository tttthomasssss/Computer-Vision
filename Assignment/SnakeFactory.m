classdef SnakeFactory
    %SNAKEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    methods (Access = public)
        function obj = SnakeFactory(n_control_points, image, feature_bb)
            obj.n_control_points = n_control_points;
            
            % Init a snake
            [x y] = obj.get_basic_snake_for_feature(feature_bb);
            
            figure(2323);
            imshow(image); hold on;
            plot(y, x, 'Marker', 'o', 'Color', 'g');
            
            [obj.x_snake obj.y_snake] = obj.fit_snake(image, [x y]);
        end
        
        
    end
    
    properties (GetAccess = public, SetAccess = public)
        n_control_points;   % Number of Control points for the snake
        snake_alpha;        % Alpha value for snake
        snake_beta;         % Beta value for snake
        x_snake;            % Vector containing x coordinates of final snake
        y_snake;            % Vector containing y coordinates of final snake
    end
    
    methods (Access = private)
        
        function [xs ys] = fit_snake(obj, image, init_control_points)
            xs = init_control_points(1, 1);
            ys = init_control_points(1, 2);
        end
        
        function [xs ys] = get_basic_snake_for_feature(obj, feature_bb)
            
            min_col = feature_bb(1, 1);
            min_row = feature_bb(1, 2);
            width = feature_bb(1, 3);
            height = feature_bb(1, 4);
            
            % Circumference of the BB
            u = 2 .* (width + height);
            
            spacing = round(u / obj.n_control_points);
            
            xs = zeros(obj.n_control_points, 1);
            ys = zeros(obj.n_control_points, 1);
            
            curr_col_pos = min_col;
            curr_row_pos = min_row;
            
            points = 1;
            
            % Top Line
            while curr_col_pos <= min_col + width && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_col_pos = curr_col_pos + spacing;
            end;
            
            % Bottom Line
            curr_col_pos = min_col;
            curr_row_pos = min_row + height;
            while curr_col_pos <= min_col + width && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_col_pos = curr_col_pos + spacing;
            end;
            
            % Left Line
            curr_col_pos = min_col;
            curr_row_pos = min_row + spacing;
            while curr_row_pos <= min_row + height - spacing && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_row_pos = curr_row_pos + spacing;
            end;
            
            % Right Line
            curr_col_pos = min_col + width;
            curr_row_pos = min_row + spacing;
            while curr_row_pos <= min_row + height - spacing && points <= obj.n_control_points
                xs(points, 1) = curr_row_pos;
                ys(points, 1) = curr_col_pos;
                points = points + 1;
                curr_row_pos = curr_row_pos + spacing;
            end;
        end
    end
    
end

