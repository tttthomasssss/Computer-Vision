classdef RegionDetector
    %REGIONDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = RegionDetector()
        end
        
        function bb_matrix = detect_bounding_boxes(obj, image, min_edge_length)
            
            if nargin < 3
                min_edge_length = Consts.MIN_EDGE_LENGTH;
            end;
            
            if ~is_binary_image(image)
                t = graythresh(image);
                image = im2bw(image, t);
            end;
            
            % Find connected regions
            cc = bwconncomp(image);

            bb_matrix = zeros(cc.NumObjects, 4);
            worthy_objects = 1;
            
            for i = 1:cc.NumObjects
                [idx_rows idx_cols] = ind2sub(size(image), cc.PixelIdxList{1, i});

                min_col = min(idx_cols);
                max_col = max(idx_cols);
                min_row = min(idx_rows);
                max_row = max(idx_rows);

                height = max_row - min_row;
                width = max_col - min_col;

                % Don't bother about a box in case its region is less than
                % the specified min_edge_length x min_edge_length
                if max_row - min_row > min_edge_length && max_col - min_col > min_edge_length
                    
                    bb_matrix(worthy_objects, :) = [min_col min_row width height];
                    worthy_objects = worthy_objects + 1;
                    
                end;
            end;
            
            bb_matrix = bb_matrix(1:worthy_objects - 1, :);
            
        end
    end
    
    properties
    end
    
    methods
    end
    
end

