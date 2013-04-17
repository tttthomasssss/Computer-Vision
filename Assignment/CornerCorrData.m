classdef CornerCorrData<handle
    %CORNERCORRDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = CornerCorrData(corner_bb, img)
            obj.img = img;
            obj.collect_data(corner_bb);
        end;
    end;
    
    properties (GetAccess = public, SetAccess = private)
        img;
        bb_width;
        bb_height;
        mid_point_gray_level;
        avg_gray_level_box_corners;
        avg_gray_level_box;
        max_gray_level;
        min_gray_level;
        bb_mid_point;
    end;
    
    methods (Access = private)
        function collect_data(obj, corner_bb)
            
            % Width & Height
            obj.bb_width = corner_bb(1, 3);
            obj.bb_height = corner_bb(1, 4);
            
            % Mid Point & Mid Point Gray Level
            obj.bb_mid_point = obj.get_bb_mid_point(corner_bb);
            obj.mid_point_gray_level = obj.img(obj.bb_mid_point(1, 1), obj.bb_mid_point(1, 2));
            
            % Corner Gray Levels
            img_size = size(obj.img);
            max_col = min(corner_bb(1, 1) + corner_bb(1, 3), img_size(1, 2));
            max_row = min(corner_bb(1, 2) + corner_bb(1, 4), img_size(1, 1));
            
            gray_level_top_left = obj.img(corner_bb(1, 2), corner_bb(1, 1));
            gray_level_top_right = obj.img(corner_bb(1, 2), max_col);
            gray_level_bottom_left = obj.img(max_row, corner_bb(1, 1));
            gray_level_bottom_right = obj.img(max_row, max_col);
            
            obj.avg_gray_level_box_corners = mean([gray_level_top_left gray_level_top_right gray_level_bottom_left gray_level_bottom_right]);
        
            % Overall Bounding Box Gray Level
            img_patch = obj.img(corner_bb(1, 2):corner_bb(1, 2) + corner_bb(1, 4), corner_bb(1, 1):corner_bb(1, 1) + corner_bb(1, 3));
            obj.avg_gray_level_box = mean(img_patch(:));
            obj.max_gray_level = max(img_patch(:));
            obj.min_gray_level = min(img_patch(:));  
        end;
        
        function mid_point = get_bb_mid_point(obj, bb)
            min_col = bb(1, 1);
            min_row = bb(1, 2);
            
            center_col = min_col + round(bb(1, 3) ./ 2);
            center_row = min_row + round(bb(1, 4) ./ 2);
            
            mid_point = [center_row center_col];
        end;
    end;
    
end

