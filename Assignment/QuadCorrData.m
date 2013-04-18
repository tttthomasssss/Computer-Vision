classdef QuadCorrData<handle
    %QUADCORRDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = QuadCorrData(blocks, bb)
            obj.blocks = blocks;
            obj.bb = bb;
            obj.bb_mid_point = obj.get_bb_mid_point(bb);
        end;
    end;
    
    properties (GetAccess = public, SetAccess = private)
        blocks;
        bb;
        bb_mid_point;
    end;
    
    methods (Access = private)
        function mid_point = get_bb_mid_point(obj, bb)
            min_col = bb(1, 1);
            min_row = bb(1, 2);
            
            center_col = min_col + round(bb(1, 3) ./ 2);
            center_row = min_row + round(bb(1, 4) ./ 2);
            
            mid_point = [center_row center_col];
        end;
    end;
end

