%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
classdef Consts
    %CONSTS Global class defining all constants
    
    properties (Constant = true)
        % Path Constants
        PATH_IMG_LEFT_BW        = 'assignment/img_left_gray.bmp';
        PATH_IMG_RIGHT_BW       = 'assignment/img_right_gray.bmp';
        PATH_IMG_LEFT_COL       = 'assignment/img_left_colour.tif';
        PATH_IMG_RIGHT_COL      = 'assignment/img_right_colour.tif';
        FULL_PATH_IMG_LEFT_BW   = '/Users/thomas/DevSandbox/TheUniSandbox/Computer Vision/resources/images/assignment/img_left_gray.bmp';
        FULL_PATH_IMG_RIGHT_BW  = '/Users/thomas/DevSandbox/TheUniSandbox/Computer Vision/resources/images/assignment/img_right_gray.bmp';
        FULL_PATH_IMG_LEFT_COL  = '/Users/thomas/DevSandbox/TheUniSandbox/Computer Vision/resources/images/assignment/img_left_colour.tif';
        FULL_PATH_IMG_RIGHT_COL = '/Users/thomas/DevSandbox/TheUniSandbox/Computer Vision/resources/images/assignment/img_right_colour.tif';
        
        % Enum Constants
        IMG_LEFT_BW     = 1;
        IMG_RIGHT_BW    = 2;
        IMG_LEFT_COL    = 3;
        IMG_RIGHT_COL   = 4;
        
        % Snake Constants
        DFLT_NUM_CONTROL_POINTS     = 30;
        MIN_SNAKE_SPACING           = 20;
        MAX_SNAKE_SPACING           = 200;
        MAX_ITERATIONS              = 5000;
        MIN_SNAKE_AREA              = 1200;
        MAX_SNAKE_DIFF_TOLERANCE    = 15000;
        MIN_SNAKE_ASPECT_RATIO      = 0.1;
        
        % Bounding Box Constants
        MIN_EDGE_LENGTH     = 30;
        MIN_BOX_AREA        = 1200;
        MAX_BOX_AREA_PROP   = 0.15;
        
        % Line Constants
        MIN_LINE_LENGTH         = 150;
        LINE_LENGTH_TOLERANCE   = 0.7;
        MAX_LINE_DIFF_TOLERANCE = 3000;
        
        % Corner Constants
        CORNER_FRAME_SIZE           = 30;
        MAX_CORNER_DIFF_TOLERANCE   = 0.15;
        
        % Quadtree Constants
        QUADTREE_IMPURITY_TOLERANCE = 0.1;
        QUADTREE_DIFF_TOLERANCE     = 1000;
        MIN_QUADTREE_BB_SIZE        = 2048;
        
        % Disparity Constants
        MAX_VERTICAL_DISPARITY      = 50;
        MAX_HORIZONTAL_DISPARITY    = 100;
    end;
end

