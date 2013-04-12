classdef LineCorrData<handle
    %LINECORRDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = LineCorrData(houghline)
            obj.collect_data(houghline)
        end;
    end;
    
    properties (GetAccess = public, SetAccess = private)
        % line based
        rho;
        theta;
        length;
        mid_point;
        start_point;
        end_point;
    end;
    
    methods (Access = private)
        function collect_data(obj, houghline)
            obj.rho = houghline.rho;
            obj.theta = houghline.theta;
            obj.start_point = houghline.point1;
            obj.end_point = houghline.point2;
            obj.length = norm(houghline.point1 - houghline.point2);
            obj.mid_point = abs(houghline.point2 - houghline.point1) / 2;
        end;
    end;
    
end

