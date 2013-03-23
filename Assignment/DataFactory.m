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
    end
    
    methods (Access = private)
        function load_images(obj)
            obj.img_left_bw = teachimage(Consts.PATH_IMG_LEFT_BW);
            obj.img_right_bw = teachimage(Consts.PATH_IMG_RIGHT_BW);
            obj.img_left_col = teachimage(Consts.PATH_IMG_LEFT_COL);
            obj.img_right_col = teachimage(Consts.PATH_IMG_RIGHT_COL);
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

