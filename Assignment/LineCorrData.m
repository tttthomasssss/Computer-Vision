%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
classdef LineCorrData<handle
    %LINECORRDATA Encapsulates line specific correspondence data
    
    methods (Access = public)
        function obj = LineCorrData(houghline)
        %LINECORRDATA constructor
            obj.collect_data(houghline);
        end;
    end;
    
    properties (GetAccess = public, SetAccess = private)
        rho;            % Hough Line Rho Value
        theta;          % Hough Line Theta Value
        length;         % Hough Line Length
        mid_point;      % Hough Line Mid Point
        start_point;    % Hough Line Start Point
        end_point;      % Hough Line End Point
    end;
    
    methods (Access = private)
        function collect_data(obj, houghline)
        %COLLECT_DATA collect all data from the given houghline
        
            obj.rho = houghline.rho;
            obj.theta = houghline.theta;
            obj.start_point = houghline.point1;
            obj.end_point = houghline.point2;
            obj.length = norm(houghline.point1 - houghline.point2);
            
            mid_x = min(houghline.point2(1, 1), houghline.point1(1, 1)) + (abs(houghline.point2(1, 1) - houghline.point1(1, 1)) / 2);
            mid_y = min(houghline.point2(1, 2), houghline.point1(1, 2)) + (abs(houghline.point2(1, 2) - houghline.point1(1, 2)) / 2);
            obj.mid_point = [mid_x mid_y];
        end;
    end;
    
end

