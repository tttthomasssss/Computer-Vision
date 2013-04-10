classdef Corresponder<handle
    %CORRESPONDER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = Corresponder()
        end
        
        function corr_bb_matrix = correlate_bounding_boxes(obj, image1, bb_matrix, image2)
            bb_size = size(bb_matrix);
            
            for i = 1:bb_size(1)
                row1 = bb_matrix(i, 2);
                row2 = row1 + bb_matrix(i, 4);
                col1 = bb_matrix(i, 1);
                col2 = col1 + bb_matrix(i, 3);
                
                template = flipud(image1(row1:row2, col1:col2));

                figure(i); imshow(template);
                
                correlated_img = convolve2(image2, template, 'valid');
                
                figure(10 + i); imshow(correlated_img, []);
                
                [rows cols vals] = findpeaks(correlated_img);
                hold on; plot(cols, rows, 'g*');
            end;
            corr_bb_matrix = 0;
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
            
            disp(region_feature);
            
            %figure; imshow(image1(region_feature));
            
            slice = image1(region_feature);
            disp(slice);
            
            % TODO: GET PROPER AREA SLICE HERE, THIS ONLY EXTRACTS THE
            % VALUES OF THE POINTS SPECIFIED BUT NOT AN AREA
            % MAYBE RATHER DO CORRELATION WITH BOUNDING BOXES....
            template = flipud(image1(region_feature));
            
            figure; imshow(template);
            
            conv_img = convolve2(image2, template, 'valid');
            
            figure;
            imshow(conv_img);
        end
        
    end
    
end

