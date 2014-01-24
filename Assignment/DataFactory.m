%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
classdef DataFactory<handle
    %DATAFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Constructor
    methods (Access = public)
        function obj = DataFactory()
            obj.load_images();
        end
        
        function edgemap = create_edgemap_for_img(obj, image_enum, edge_detection_method)
            if nargin < 3
                edge_detection_method = 'canny';
            end;
            
            img = obj.image_for_enum(image_enum);
        
            edgemap = edge(img, edge_detection_method);
        end
        
        function morphed_img = morph_edgemap(obj, edgemap, operation, n)
            if nargin < 4
                n = 1;
            end
            
            morphed_img = bwmorph(edgemap, operation, n);
        end
        
        function dil_grayscale_img = dilate_grayscale_img(obj, image, n, strel_method, strel_param)
            if nargin < 4
                strel_method = 'diamond';
                strel_param = 1;
            elseif nargin < 5
                strel_param = 1;
            end;
            
            se = strel(strel_method, strel_param);
            
            dil_grayscale_img = image;
            
            for i = 1:n
                dil_grayscale_img = imdilate(dil_grayscale_img, se);
            end;
        end
        
        function vector_peaks = find_vector_peaks(obj, vector, minpeakdistance, minpeakhight)
            
            if nargin < 3
                minpeakdistance = 1;
                minpeakheight = 0;
            elseif nargin < 4
                minpeakheight = 0;
            end;
            
            [rows cols] = size(vector);
            
            % Convert row vector to column vector
            if rows > cols
                vector = vector.';
                [rows cols] = size(vector);
            end;
            
            peaks = zeros(1, cols);
            
            for i = 1:cols
                
                if vector(1, i) > minpeakheight
                    min_idx = max(0, i - minpeakdistance);
                    max_idx = min(cols, i + minpeakdistance);
                    
                    j = min_idx;
                    while j <= max_idx && vector(1, i) >= vector(1, j)
                        j = j + 1;
                    end;
                    
                    if j > max_idx
                        peaks(i) = 1;
                    end;
                end;
            end;
            
            vector_peaks = find(peaks == 1);
        end
    end
    
    methods (Access = private)
        function load_images(obj)
            obj.img_left_bw = teachimage(Consts.PATH_IMG_LEFT_BW);
            obj.img_right_bw = teachimage(Consts.PATH_IMG_RIGHT_BW);
            obj.img_left_col = imread(Consts.FULL_PATH_IMG_LEFT_COL);
            obj.img_right_col = imread(Consts.FULL_PATH_IMG_RIGHT_COL);
        end
        
        function img = image_for_enum(obj, enum)
            switch enum
                case Consts.IMG_LEFT_BW
                    img = obj.img_left_bw;
                case Consts.IMG_RIGHT_BW
                    img = obj.img_right_bw;
                case Consts.IMG_LEFT_COL
                    img = obj.img_left_col;
                case Consts.IMG_RIGHT_COL
                    img = obj.img_right_col;
                otherwise
                    img = NaN;
            end
        end
    end
    
    properties (GetAccess = public, SetAccess = private)
        img_left_bw;    % Left Image Black/White
        img_right_bw;   % Right Image Black/White
        img_left_col;   % Left Image Colour
        img_right_col;  % Right Image Colour
    end
    
    
end

