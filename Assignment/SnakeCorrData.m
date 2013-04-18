classdef SnakeCorrData<handle
    %SNAKECORRDATA encapsulates correspondence relevant data for snakes
    
    methods(Access = public)
        function obj = SnakeCorrData(snake, bb)
        %SNAKECORRDATA constructor
        %
        %   initialises the object with the snake and its bounding box
            obj.collect_data(snake, bb);
        end;
    end
    
    properties (GetAccess = public, SetAccess = private)
        snake_area;                 % Area of the Snake
        snake_circumference;        % Circumference of the Snake
        snake_area_circum_ratio;    % Ratio between Area and Circumference
        snake_height;               % Maximum vertical expansion
        snake_width;                % Maximum horizontal expansion
        bb_mid_point;               % Mid point of the bounding box
        
    end
    
    methods (Access = private)
        function collect_data(obj, snake, bb)
        %COLLECT_DATA collect all the data given the snake and its bounding
        %box
            obj.snake_area              = uint16(polyarea(snake(:, 1), snake(:, 2)));
            obj.snake_circumference     = obj.get_circumference(snake);
            obj.snake_area_circum_ratio = obj.snake_area ./ obj.snake_circumference;
            obj.snake_height            = max(snake(:, 1)) - min(snake(:, 1));
            obj.snake_width             = max(snake(:, 2)) - min(snake(:, 2)); 
            obj.bb_mid_point            = obj.get_bb_mid_point(bb);
        end;
        
        function c = get_circumference(obj, snake)
        %GET_CIRCUMFERENCE determine and return the circumference of the
        %snake
            c = 0;
            for i = 1:length(snake) - 1
                p1 = snake(i, :);
                p2 = snake(i + 1, :);
                c = c + norm([abs(p2(1, 1) - p1(1, 1)) abs(p2(1, 2) - p1(1, 2))]);
            end;
        end;
        
        function mid_point = get_bb_mid_point(obj, bb)
        %GET_BB_MID_POINT determine and return the mid point of the snakes
        %bounding box
            min_col = bb(1, 1);
            min_row = bb(1, 2);
            
            center_col = min_col + round(bb(1, 3) ./ 2);
            center_row = min_row + round(bb(1, 4) ./ 2);
            
            mid_point = [center_row center_col];
        end;
    end 
end

