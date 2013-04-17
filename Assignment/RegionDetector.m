classdef RegionDetector<handle
    %REGIONDETECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = RegionDetector()
        end
        
        function bb_matrix = detect_bounding_boxes(obj, image, min_box_area, max_box_area)
            
            if nargin < 3
                min_box_area = Consts.MIN_BOX_AREA;
                
                % Take Max Box Area as proportion of the image
                [rows cols] = size(image);
                max_box_area = round(rows * cols * Consts.MAX_BOX_AREA_PROP);
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
                % the specified min_box_area or greater than the specified
                % max_box_area
                if obj.check_worthy_object(height, width, min_box_area, max_box_area)
                    
                    bb_matrix(worthy_objects, :) = [min_col min_row width height];
                    worthy_objects = worthy_objects + 1;
                    
                end;
            end;
            
            bb_matrix = bb_matrix(1:worthy_objects - 1, :);
            
        end
        
        function corner_bins = cluster_corners(obj, corners)
            
            corner_bins = cell(1, 1);
            bin_count = 1;
            num_corners = length(corners);

            while num_corners > 1
                x = corners(1, 1);
                y = corners(1, 2);
    
                x_idx_in_range = find(corners(:, 1) <= x + Consts.CORNER_FRAME_SIZE & corners(:, 1) >= x - Consts.CORNER_FRAME_SIZE);
                y_idx_in_range = find(corners(:, 2) <= y + Consts.CORNER_FRAME_SIZE & corners(:, 2) >= y - Consts.CORNER_FRAME_SIZE);
    
                idx_intersect = intersect(x_idx_in_range, y_idx_in_range);
    
                corner_bins{bin_count, 1} = corners(idx_intersect, :);
                bin_count = bin_count + 1;
    
                corners = setdiff(corners, corners(idx_intersect, :), 'rows');
                num_corners = num_corners - length(idx_intersect);
            end;
        end;
        
        function bb_matrix = extract_bounding_box_patches_from_corner_clusters(obj, corner_bins, img)
            
            bb_matrix = zeros(length(corner_bins), 4);
            
            img_size = size(img);
            
            for i = 1:length(corner_bins)
                bin = corner_bins{i, 1};
    
                bin_size = size(bin);
                if (bin_size(1, 1) == 1)
                    % Single Corner
                    mid_col = bin(1, 1);
                    mid_row = bin(1, 2);
        
                    frame_size = Consts.CORNER_FRAME_SIZE;
                elseif (bin_size(1, 1) == 2)
                    % "Edge" Corner
                    mid_col = round(min(bin(1, 1), bin(2, 1)) + abs(bin(1, 1) - bin(2, 1)) / 2);
                    mid_row = round(min(bin(1, 2), bin(2, 2)) + abs(bin(1, 2) - bin(2, 2)) / 2);
        
                    frame_size = Consts.CORNER_FRAME_SIZE;
                else
                    % Geometric Corner
                    [geom iner cpmo] = polygeom(bin(:, 1), bin(:, 2));
                    mid_col = round(geom(2));
                    mid_row = round(geom(3));
        
                    frame_size = max(bin(:) - min(bin(:)));
                end;
    
                min_col = max(mid_col - frame_size, 1);
                max_col = min(mid_col + frame_size, img_size(1, 2));
                min_row = max(mid_row - frame_size, 1);
                max_row = min(mid_row + frame_size, img_size(1, 1));
        
                height = max_row - min_row;
                width = max_col - min_col;
        
                bb_matrix(i, :) = [min_col min_row width height];
            end;
        end
    end
    
    properties
    end
    
    methods (Access = private)
        function worthy = check_worthy_object(obj, height, width, min_box_area, max_box_area)
            
            worthy = ternary_conditional((height * width > min_box_area) && (height * width < max_box_area) , 1, 0);
        
        end
    end
end

