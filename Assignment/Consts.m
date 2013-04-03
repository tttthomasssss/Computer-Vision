classdef Consts
    %CONSTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant = true)
        % Path Constants
        PATH_IMG_LEFT_BW    = 'assignment/img_left_gray.bmp';
        PATH_IMG_RIGHT_BW   = 'assignment/img_right_gray.bmp';
        PATH_IMG_LEFT_COL   = 'assignment/img_left_colour.tif';
        PATH_IMG_RIGHT_COL  = 'assignment/img_right_colour.tif';
        
        % Enum Constants
        IMG_LEFT_BW     = 1;
        IMG_RIGHT_BW    = 2;
        IMG_LEFT_COL    = 3;
        IMG_RIGHT_COL   = 4;
        
        % Snake Constants
        DFLT_NUM_CONTROL_POINTS     = 30;
        MIN_SNAKE_SPACING           = 20;
        MAX_SNAKE_SPACING           = 200;
        
        % Bounding Box Constants
        MIN_EDGE_LENGTH     = 30;
    end
    
    methods
    end
    
end

