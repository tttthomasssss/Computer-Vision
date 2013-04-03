classdef Corresponder
    %CORRESPONDER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = Corresponder()
        end
        
        function match_regions(obj, image1, region_features, image2, correspondence_method)
            
            if nargin < 5
                correspondence_method = Consts.CORRESPONDENCE_BY_CORRELATION;
            end;
            
            if correspondence_method == Consts.CORRESPONDENCE_BY_CORRELATION
                
                for i = 1:length(region_features)
                    obj.match_region_by_correlation(image1, region_features{i}, image2);
                end;
                
            else
                disp('Do other stuff');
            end;
        end
    end
    
    properties
    end
    
    methods (Access = private)
        
        function match_region_by_correlation(obj, image1, region_feature, image2)
            
            % TODO: Remove me
            close all;
            
            % TODO: GET PROPER AREA SLICE HERE
            template = flipud(image1(region_feature));
            
            figure; imshow(template);
            
            conv_img = convolve2(image2, template, 'valid');
            
            figure;
            imshow(conv_img);
        end
        
    end
    
end

