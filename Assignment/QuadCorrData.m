%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
classdef QuadCorrData<handle
    %QUADCORRDATA Encapsulates Quadtree specific data
    
    methods (Access = public)
        function obj = QuadCorrData(blocks, bb)
        %QUADCORRDATA constructor
            obj.blocks = blocks;
            obj.bb = bb;
            obj.bb_mid_point = obj.get_bb_mid_point(bb);
        end;
    end;
    
    properties (GetAccess = public, SetAccess = private)
        blocks;         % data structure holding the actual quadtree
        bb;             % bounding box of quadtree
        bb_mid_point;   % mid point of bounding box of quadtree
    end;
    
    methods (Access = private)
        function mid_point = get_bb_mid_point(obj, bb)
        %GET_BB_MID_POINT determines and returns the mid point of the given
        %bounding box
            min_col = bb(1, 1);
            min_row = bb(1, 2);
            
            center_col = min_col + round(bb(1, 3) ./ 2);
            center_row = min_row + round(bb(1, 4) ./ 2);
            
            mid_point = [center_row center_col];
        end;
    end;
end

