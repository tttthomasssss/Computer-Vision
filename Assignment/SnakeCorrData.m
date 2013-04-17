classdef SnakeCorrData<handle
    %SNAKECORRDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Access = public)
        function obj = SnakeCorrData(snake, bb)
            obj.collect_data(snake, bb)
        end;
    end
    
    properties (GetAccess = public, SetAccess = private)
        % area based
        snake_area;
        snake_circumference;
        snake_area_circum_ratio;
        snake_height;
        snake_width;
        bb_mid_point;
        
    end
    
    methods (Access = private)
        function collect_data(obj, snake, bb)
            obj.snake_area = uint16(polyarea(snake(:, 1), snake(:, 2)));
            obj.snake_circumference = obj.get_circumference(snake);
            obj.snake_area_circum_ratio = obj.snake_area ./ obj.snake_circumference;
            obj.snake_height = max(snake(:, 1)) - min(snake(:, 1));
            obj.snake_width = max(snake(:, 2)) - min(snake(:, 2)); 
            obj.bb_mid_point = obj.get_bb_mid_point(bb);
        end;
        
        function c = get_circumference(obj, snake)
            c = 0;
            for i = 1:length(snake) - 1
                p1 = snake(i, :);
                p2 = snake(i + 1, :);
                c = c + norm([abs(p2(1, 1) - p1(1, 1)) abs(p2(1, 2) - p1(1, 2))]);
            end;
        end;
        
        function mid_point = get_bb_mid_point(obj, bb)
            min_col = bb(1, 1);
            min_row = bb(1, 2);
            
            center_col = min_col + round(bb(1, 3) ./ 2);
            center_row = min_row + round(bb(1, 4) ./ 2);
            
            mid_point = [center_row center_col];
        end;
    end
    
end

